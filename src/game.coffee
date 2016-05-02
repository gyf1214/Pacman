global.game = (initial, data, turn) ->
  statics = contents = players =
  generators = nextGenerate = delta = null
  consts = {}
  backtrack = []

  initConsts = (data) ->
    map =
      width: "width"
      height: "height"
      interval: "GENERATOR_INTERVAL"
      duration: "LARGE_FRUIT_DURATION"
      enhance: "LARGE_FRUIT_ENHANCEMENT"
    consts[i] = data[x] for i, x of map
    null

  initContents = (data, s) ->
    statics = s
    contents = data.contents
    players = data.players
    nextGenerate = data.nextGenerate
    generators = []
    for i in [0..consts.height-1]
      for j in [0..consts.width-1]
        players[id] ||= (
          i: i, j: j
          duration: 0
          strength: 1
          dead: false
        ) for id in [0..3] when contents[i][j] & mask.player(id)
        generators.push i: i, j: j if statics[i][j] & mask.generator
    null

  init = (initial, data) ->
    initConsts initial
    data ||=
      contents: initial.content
      players: []
      nextGenerate: consts.interval
    initContents data, initial.static
    null

  valid = (id, dir, p) ->
    p ||= players[id]
    dir == -1 || (dir >= -1 && dir < 4 &&
    !(statics[p.i][p.j] & mask.wall(dir)))

  kill = (p, id) ->
    contents[p.i][p.j] &= ~mask.player(id)
    p.dead = true

  front = (i, j, dir) ->
    d = direction dir
    i: (i + d.i + consts.height) % consts.height
    j: (j + d.j + consts.width) % consts.width

  checkValid = (p, id, actions) ->
    dir = actions[id].action
    return if dir == -1
    unless valid id, dir
      p.strength = 0
      kill p, id

    else
      pos = front p.i, p.j, dir
      target = contents[pos.i][pos.j]
      (actions[id].action = -1) for i in [0..3] when target &
      mask.player(i) && (players[i].strength > p.strength)
    null

  move = (p, id, dir) ->
    return if dir == -1
    contents[p.i][p.j] &= ~mask.player(id)
    pos = front p.i, p.j, dir
    [p.i, p.j] = [pos.i, pos.j]
    contents[p.i][p.j] |= mask.player(id)
    null

  fight = (i, j) ->
    fighters = ([p, id] for p, id in players when !p.dead &&
    contents[i][j] & mask.player(id))
    return if fighters.length <= 1
    loot = winners = max = 0
    (max = f[0].strength) for f in fighters when f[0].strength > max
    for f in fighters
      if f[0].strength == max
        ++winners
      else
        drop = Math.floor(f[0].strength / 2)
        loot += drop
        f[0].strength -= drop
        kill f[0], f[1]
    loot = Math.floor(loot / winners)
    (f[0].strength += loot) for f in fighters when f[0].strength == max

  generate = () ->
    nextGenerate = consts.interval
    for g in generators
      for dir in [0..7]
        t = front g.i, g.j, dir
        unless statics[t.i][t.j] & mask.generator ||
        (contents[t.i][t.j] & (mask.small | mask.big))
          contents[t.i][t.j] |= mask.small
          delta.newFruits.push t

  eat = (p, id) ->
    c = contents[p.i][p.j]
    unless c & ~mask.player(id) & mask.players
      if c & mask.small
        t = i: p.i, j: p.j, mask: mask.small
        delta.eatFruits.push t
        contents[p.i][p.j] &= ~mask.small
        ++p.strength
      else if c & mask.large
        t = i: p.i, j: p.j, mask: mask.large
        delta.eatFruits.push t
        contents[p.i][p.j] &= ~mask.large
        p.strength += consts.enhance if p.duration == 0
        p.duration += consts.duration
    if p.duration > 0 && --p.duration == 0
      p.strength -= consts.enhance

  nextTurn = (actions) ->
    ++turn
    delta =
      players: JSON.parse JSON.stringify players
      newFruits: []
      eatFruits: []

    checkValid p, id, actions for p, id in players when !p.dead
    move p, id, actions[id].action for p, id in players when !p.dead
    fight p.i, p.j for p, id in players when !p.dead
    generate() if --nextGenerate == 0
    eat p, id for p, id in players when !p.dead

    backtrack.push delta

    lives = (p for p in players when !p.dead)
    if lives.length == 1
      p = lives[0]
      cnt = 0
      for i in [0..consts.height-1]
        for j in [0..consts.width-1]
          if contents[i][j] & mask.small
            ++cnt
      p.strength += cnt
    lives.length == 1 || turn >= maxTurn

  popState = () ->
    return if backtrack.length == 0
    --turn
    delta = backtrack.pop()
    contents[p.i][p.j] &= ~mask.player(id) for p, id in players when !p.dead
    players = delta.players
    contents[p.i][p.j] |= mask.player(id) for p, id in players when !p.dead
    contents[f.i][f.j] |= f.mask for f in delta.eatFruits
    if nextGenerate++ == consts.interval
      contents[f.i][f.j] &= ~mask.small for f in delta.newFruits
      nextGenerate = 1
    null

  getData = () ->
    contents: contents
    players: players
    nextGenerate: nextGenerate

  getInfo = () ->
    consts: consts
    statics: statics
    generators: generators
    turn: turn

  rank = (id) ->
    ret = 0
    ++ret for p in players when p.strength < players[id].strength
    ret

  getFruits = () ->
    small = large = []
    for i in [0..consts.height-1]
      for j in [0..consts.width-1]
        small.push {i:i, j:j} if contents[i][j] & mask.small
        large.push {i:i, j:j} if contents[i][j] & mask.large
    small: small
    large: large

  init initial, data

  exports =
    getData: getData
    nextTurn: nextTurn
    popState: popState
    valid: valid
    getInfo: getInfo
    getFruits: getFruits
    rank: rank
    front: front
