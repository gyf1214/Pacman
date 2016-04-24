@game = (() ->
  statics = contents = players = generators = nextGenerate = null
  consts = {}

  initConsts = (data) ->
    map =
      width: "width"
      height: "height"
      interval: "GENERATOR_INTERVAL"
      duration: "LARGE_FRUIT_DURATION"
      enhance: "LARGE_FRUIT_ENHANCEMENT"
    consts[i] = data[x] for i, x of map
    null

  initField = (s, c) ->
    statics = s
    contents = c
    null

  initContents = (data) ->
    generators = data.generators
    players = data.players
    unless (nextGenerate = data.nextGenerate)?
      nextGenerate = consts.interval
      for l, i in contents
        for x, j in l
          players[id] = (
            i: i
            j: j
            duration: 0
            strenth: 1
            dead: false
          ) for id in [0..3] when x & @mask.player(id)
          generators.push i: i, j: j if x & @mask.generator
    null


  init = (input, data) ->
    initial = input.requests[0]
    data ||=
      contents: initial.content
      players: []
      generators: []
    initConsts(initial)
    initField(initial.static, data.contents)
    initContents(data)
    null

  getData = () ->
    data.nextGenerate = nextGenerate
    data

  exports =
    init: init
    getData: getData
).bind this
