extends Node

var min_x: int = 4
var max_x: int = 8
var min_y: int = 3
var max_y: int = 7
var max_direction_count = 5

const tile_size: int = 16
const half_tile_size: int = tile_size / 2

enum Difficulty {
	EASY,
	MEDIUM,
	HARD
}

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


func change_difficulty(new: int) -> void:
	match new:
		Difficulty.EASY:
			min_x = 4
			max_x = 8
			min_y = 3
			max_y = 7
			max_direction_count = 3
			pass
		Difficulty.MEDIUM:
			min_x = 3
			max_x = 9
			min_y = 2
			max_y = 8
			max_direction_count = 4
			pass
		Difficulty.HARD:
			min_x = 1
			max_x = 11
			min_y = 1
			max_y = 9
			max_direction_count = 5
			pass
