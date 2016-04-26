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
    game = global.game request.requests[0], data.game
    if (len = request.requests.length) > 1
      game.nextTurn request.requests[len - 1]
    null

  initNav = () ->
    nav = global.navigator data.navigator
    null

  random = () ->
    valids = (dir for dir in [0..3] when game.valid me, dir)
    valids.push -1 if valids.length == 0
    id = Math.floor Math.random() * valids.length
    action: valids[id]
    tauntText: "Hello World!"

  respond = (req) ->
    getData(req)
    initGame()
    initNav()
    data =
      game: game.getData()
      navigator: nav.getData()
    response: random()
    data: JSON.stringify data
    debug: JSON.stringify data

  exports =
    respond: respond
)
