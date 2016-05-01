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

  pick = (s) ->
    valids = (dir for dir in [0..3] when game.valid me, dir)
    valids.push -1
    [max, best] = [-1, -1]
    for dir in valids
      ans = s.evaluate dir
      # console.log ans
      [max, best] = [ans, dir] if ans > max
    best

  respond = (req) ->
    getData(req)
    initGame()
    initNav()
    simulator = global.simulator game, me
    greedy = global.greedy game, nav, me
    response =
      action: pick greedy
      tauntText: ""
    data =
      game: game.getData()
      navigator: nav.getData()
    response: response
    data: JSON.stringify data

  exports =
    respond: respond
)
