extends Node

var _memory_path

var current_row = Globals.min_y
var current_column
var points = []

var right_count = 0
var down_count = 0
var left_count = 0
const max_direction_count = 5

enum Directions {
	DOWN,
	RIGHT,
	LEFT
}

# Returns a random int value between two points
func rnd(from: int, to: int) -> int:
	randomize()
	return int(rand_range(from, to))

# Returns the starting position of the line
func get_starting_position() -> int:
	return rnd(Globals.min_x, Globals.max_x)

# Checks if "right" is free
func can_go_right(column: int) -> bool:
	# On the right edge
	if column == Globals.max_x or points.find([column + 1, current_row]) != -1 or right_count >= max_direction_count:
		return false
	
	return true

# Checks if "left" is free
func can_go_left(column: int) -> bool:
	# On the left edge
	if column == Globals.min_x or points.find([column - 1, current_row]) != -1 or left_count >= max_direction_count:
		return false
	
	return true

# Decides in which direction the line wants to go
func make_direction_decision(column: int) -> String:
	var directions = [Directions.DOWN]
	
	if can_go_right(column):
		directions.append(Directions.RIGHT)
	
	if can_go_left(column):
		directions.append(Directions.LEFT)
	
	return directions[rnd(0, len(directions))]

# Generate the pathway
func generate(path: Line2D) -> Line2D:
	_memory_path = path
	current_column = get_starting_position()
	points.append([current_column, current_row])
	
	while current_row < Globals.max_y:
		var direction = make_direction_decision(current_column)
		match direction:
			Directions.DOWN:
				current_row += 1
				down_count += 1
				right_count = 0
				left_count = 0
			Directions.RIGHT:
				current_column += 1
				right_count += 1
				down_count = 0
				left_count = 0
			Directions.LEFT:
				current_column -= 1
				left_count += 1
				down_count = 0
				right_count = 0
		points.append([current_column, current_row])
	
	for idx in len(points):
		_memory_path.add_point(Globals.get_line_point(points[idx][0], points[idx][1]))
	
	return _memory_path
