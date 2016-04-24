@judge = (() ->
  res =
    action: -1
    tauntText: 'Hello World!'
  respond: (request) ->
    response: res
    data: request.data ||= ""
).call this
