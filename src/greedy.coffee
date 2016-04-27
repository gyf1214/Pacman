global.greedy = (game, nav, me) ->
  p = i = d = f = g = null

  dMix = 10
  sMix = 0.1
  lMix = 0.3
  gMix = 5

  fruitVal = () ->
    f = game.getFruits()
    ret = 0
    (ret += sMix / nav.get(p, s)) for s in f.small
    (ret += lMix / nav.get(p, s)) for s in f.large
    ret

  generatorVal = () ->
    g = i.generators
    ret = 0
    # TODO:

  strengthVal = () ->
    p = d.players[me]
    ret = p.strength
    ret -= dMix * (1 - p.duration / i.consts.duration) if p.duration > 0
    ret

  evaluate = (dir) ->
    s = simulator game, me
    s.randomMove dir
    i = game.getInfo()
    d = game.getData()
    ret = strengthVal() + fruitVal() + generatorVal()
    game.popState()
    ret

  # pick = () ->
  #

  exports =
    evaluate: evaluate
