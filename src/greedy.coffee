global.greedy = (game, nav, me) ->
  p = i = d = f = g = null

  actions = sum = cnt = null

  dMix = 10
  sMix = 0.2
  lMix = 0.6
  gMix = 0.2

  fruitVal = () ->
    f = game.getFruits()
    ret = 0
    (ret += sMix / (1 + nav.get(p, s))) for s in f.small
    (ret += lMix / (1 + nav.get(p, s))) for s in f.large
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
    ret -= dMix * (1 - p.duration / i.consts.duration) if p.duration > 0
    ret

  value = () ->
    t = (action: i for i in actions)
    game.nextTurn t
    i = game.getInfo()
    d = game.getData()
    ret = strengthVal() + fruitVal() + generatorVal()
    game.popState()
    ret

  dfs = (i) ->
    i++ while actions[i]?
    if i >= 4
      sum += value()
      ++cnt
    else
      valids = (dir for dir in [-1..3] when game.valid i, dir)
      for dir in valids
        actions[i] = dir
        dfs i + 1
        actions[i] = null
    null

  evaluate = (dir) ->
    sum = 0
    cnt = 0
    actions = []
    actions[me] = dir
    dfs 0
    sum / cnt

  exports =
    evaluate: evaluate
