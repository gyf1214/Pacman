global.greedy = (game, nav, me) ->
  p = i = d = f = g = null

  actions = sum = cnt = ans = null

  dMix = 10
  sMix = 0.2
  lMix = 0.3
  gMix = 0.2

  rev = (a) ->
    return 0 if a == 0
    1 / a / a

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
        ret += gMix * rev(1 + t) if t?
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
    # console.log ret
    ret

  dfs = (i) ->
    i++ while actions[i]?
    if i >= 4
      t = value()
      ans = if ans? && ans <= t then ans else t
    else
      valids = (dir for dir in [-1..3] when game.valid i, dir)
      for dir in valids
        actions[i] = dir
        dfs i + 1
        actions[i] = null
    null

  evaluate = (dir) ->
    ans = null
    actions = []
    actions[me] = dir
    dfs 0
    ans

  exports =
    evaluate: evaluate
