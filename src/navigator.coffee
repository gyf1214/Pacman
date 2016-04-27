global.navigator = (distance, game) ->
  statics = null

  update = (u, v, d) ->
    distance[u.i][u.j][v.i] || = []
    distance[u.i][u.j][v.i][v.j] = d

  get = (u, v) ->
    distance[u.i][u.j][v.i] ||= []
    distance[u.i][u.j][v.i][v.j]

  mp = (i, j) ->
    i: i, j: j

  bfs = (i, j) ->
    distance[i] ||= []
    distance[i][j] ||= []
    q = [st = mp(i, j)]
    update st, st, 0
    while q.length > 0
      u = q.shift()
      dis = get st, u
      for d in [0..3] when !(statics[u.i][u.j] & mask.wall(d))
        v = game.front u.i, u.j, d
        unless (statics[v.i][v.j] & mask.generator) || get(st, v)?
          update st, v, dis + 1
          q.push v
    null

  calc = () ->
    distance = []
    consts = game.getInfo().consts
    statics = game.getInfo().statics
    for i in [0..consts.height-1]
      for j in [0..consts.width-1]
        bfs i, j unless statics[i][j] & mask.generator
    null

  init = () ->
    calc() unless distance?
    null

  getData = () -> distance

  init()

  exports =
    init: init
    getData: getData
    get: get
