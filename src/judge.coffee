global.judge = (() ->
  me = request = game = data = null

  initGame = () ->
    me = request.requests[0].id
    game = global.game()
    request.data ||= null
    data = JSON.parse request.data
    game.init request.requests[0], data
    if (len = request.requests.length) > 1
      game.nextTurn request.requests[len - 1]
    data = game.getData()
    null

  random = () ->
    valids = (dir for dir in [0..3] when game.valid me, dir)
    valids.push -1 if valids.length == 0
    id = Math.floor Math.random() * valids.length
    action: valids[id]
    tauntText: "Hello World!"

  respond = (req) ->
    request = req
    initGame()
    response: random()
    data: JSON.stringify data
    debug: JSON.stringify data

  respond: respond
)()
