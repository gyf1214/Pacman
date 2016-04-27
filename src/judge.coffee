global.judge = (() ->
  me = data = request = game = nav = null

  getData = (req) ->
    request = req
    request.data ||= null
    data = JSON.parse request.data
    data ||= {}
    null

  initGame = () ->
    me = request.requests[0].id
    len = request.requests.length
    game = global.game request.requests[0], data.game,
    if len > 1 then len - 2 else 0
    game.nextTurn request.requests[len - 1] if len > 1
    null

  initNav = () ->
    nav = global.navigator data.navigator, game
    null

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
    while !randomMove(dir)
      dir = null
      ++turns
    ret = game.rank me
    game.popState() while turns--
    ret

  evaluate = () ->
    valids = (dir for dir in [-1..3] when game.valid me, dir)
    max = -1
    best = -1
    for i in valids
      times = 120
      ans = 0
      ans += randomPlay i while times--
      if ans > max
        max = ans
        best = i
    best

  respond = (req) ->
    getData(req)
    initGame()
    initNav()
    response =
      action: evaluate()
      tauntText: ""
    data =
      game: game.getData()
      navigator: nav.getData()
    response: response
    data: JSON.stringify data

  exports =
    respond: respond
)
