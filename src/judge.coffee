global.judge = (() ->
  res =
    action: -1
    tauntText: 'Hello World!'
  respond: (request) ->
    game = global.game()
    request.data ||= null
    data = JSON.parse request.data
    game.init request.requests, data
    data = game.getData()
    response: res
    data: JSON.stringify data
)()
