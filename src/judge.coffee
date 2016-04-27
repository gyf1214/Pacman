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

  respond = (req) ->
    getData(req)
    initGame()
    initNav()
    simulator = global.simulator game, me
    response =
      action: simulator.pick()
      tauntText: ""
    data =
      game: game.getData()
      navigator: nav.getData()
    response: response
    data: JSON.stringify data

  exports =
    respond: respond
)
