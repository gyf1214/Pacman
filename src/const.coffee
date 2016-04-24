@mask =
  player: (id) -> 1 << id
  small: 1 << 4
  large: 1 << 5
  wall: (id) -> 1 << id
  generator: 1 << 4

@direction = (id) ->
  dx = [0, 1, 0, -1, 1, 1, -1, -1]
  dy = [-1, 0, 1, 0, -1, 1, 1, -1]
  x: dx[id]
  y: dy[id]
