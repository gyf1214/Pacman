global.navigator = (data, statics = null) ->
  distance = null

  calc = (statics) ->
    # TODO:
    null

  init = (data, statics = null) ->
    if data?
      distance = data
    else
      distance = calc statics
    null

  getData = () -> distance

  init data, statics

  exports =
    init: init
    getData: getData
