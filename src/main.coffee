input = ""

process.stdin.resume()
process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (chunk) ->
  input += chunk
  null
process.stdin.on 'end', () =>
  request = JSON.parse input
  console.log JSON.stringify @judge.respond(request)
  null
