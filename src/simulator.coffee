global.simulator = (game, me) ->
  tryTimes = 120

  random = (id = me) ->
    valids = (dir for dir in [-1..3] when game.valid id, dir)
    id = Math.floor Math.random() * valids.length
    valids[id]

  randomMove = (dir) ->
    actions = ((action: random i) for i in [0..3])
    actions[me] = action: dir if dir?
    game.nextTurn actions

  randomPlay = (dir) ->
    turns = 1
    while !randomMove dir
      dir = null
      ++turns
    ret = game.rank me
    game.popState() while turns--
    ret

  simulate = (dir) ->
    times = tryTimes
    ans = 0
    ans += randomPlay dir while times--
    ans

  pick = () ->
    valids = (dir for dir in [-1..3] when game.valid me, dir)
    [max, best] = [-1, -1]
    for i in valids
      ans = simulate i
      [max, best] = [ans, i] if ans > max
    best

  exports =
    random: random
    simulate: simulate
    pick: pick
