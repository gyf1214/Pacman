global.mask =
  player: (id) -> 1 << id
  players: (1 << 4) - 1
  small: 1 << 4
  large: 1 << 5
  wall: (id) -> 1 << id
  generator: 1 << 4

global.direction = (id) ->
  dx = [0, 0, 1, 0, -1, 1, 1, -1, -1]
  dy = [0, -1, 0, 1, 0, -1, 1, 1, -1]
  j: dx[id + 1]
  i: dy[id + 1]
