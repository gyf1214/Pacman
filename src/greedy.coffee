global.greedy = (game, nav, me) ->
  p = i = d = f = g = null

  actions = sum = cnt = ans = null

  depth = 2

  times = 500

  dMix = 5
  sMix = 0.2
  lMix = 0.3
  gMix = 0.2

  rev = (a) ->
    return 0 if a == 0
    1 / a

  fruitVal = () ->
    f = game.getFruits()
    ret = 0
    for s in f.small
      (ret += sMix * rev(nav.get(p, s)))
    for s in f.large
      (ret += lMix * rev(nav.get(p, s)))
    ret

  generatorVal = () ->
    g = i.generators
    ret = 0
    for s in g
      for dir in [0..7]
        t = nav.get p, game.front s.i, s.j, dir
        ret += gMix / (1 + t) if t?
    ret / d.nextGenerate

  strengthVal = () ->
    p = d.players[me]
    ret = p.strength
    ret -= dMix if p.duration > 0
    ret

  value = () ->
    i = game.getInfo()
    d = game.getData()
    strengthVal() + fruitVal() + generatorVal()

  valueGreed = () ->
    t = (action: i for i in actions)
    game.nextTurn t
    ret = value()
    game.popState()
    ret

  valueMont = () ->
    simulator = global.simulator game, me
    simulator.randomMove dir for dir in actions
    ret = value()
    game.popState() for dir in actions
    ret

  mont = (i, player) ->
    if i >= depth
      logger actions
      t = 0
      t += valueMont() for i in [1..times]
      logger t
      ans = if ans? && ans >= t then ans else t
    else
      for dir in [-1..3] when game.valid null, dir, player
        actions[i] = dir
        mont i + 1, game.front(player.i, player.j, dir)
        actions[i] = null
    null

  dfs = (i) ->
    i++ while actions[i]?
    if i >= 4
      t = valueGreed()
      ans = if ans? && ans <= t then ans else t
    else
      for dir in [-1..3] when game.valid i, dir
        actions[i] = dir
        dfs i + 1
        actions[i] = null
    null

  evalGreed = (dir) ->
    ans = null
    actions = []
    actions[me] = dir
    dfs 0
    ans

  evalMont = (dir) ->
    ans = null
    actions = [dir]
    player = game.getData().players[me]
    t = game.front player.i, player.j, dir
    mont 1, t
    ans

  exports =
    evaluate: evalMont
