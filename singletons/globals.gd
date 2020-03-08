extends Node

const min_x: int = 1
const min_y: int = 1
const max_x: int = 11
const max_y: int = 9

const tile_size: int = 16
const half_tile_size: int = tile_size / 2

# Gets an accurate line2d point from tile position
func get_line_point(x: int, y: int) -> Vector2:
	return Vector2(
		(x * tile_size) + half_tile_size,
		(y * tile_size) + half_tile_size
	)


func reverse_line_point(point: Vector2) -> Vector2:
	return Vector2(
		(point.x - half_tile_size) / tile_size,
		(point.y - half_tile_size) / tile_size
	)
