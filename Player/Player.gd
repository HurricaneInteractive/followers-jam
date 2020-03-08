extends Node2D

var current_position = []

func _process(delta):
	var new_position = Globals.get_line_point(current_position[0], current_position[1])
	self.position = self.position.linear_interpolate(new_position, 15 * delta)


func _input(event):
	if Input.is_action_just_pressed("ui_right"):
		if current_position[0] != Globals.max_x:
			current_position = [current_position[0] + 1, current_position[1]]
	if Input.is_action_just_pressed("ui_left"):
		if current_position[0] != Globals.min_x:
			current_position = [current_position[0] - 1, current_position[1]]
	if Input.is_action_just_pressed("ui_down"):
		if current_position[1] != Globals.max_y:
			current_position = [current_position[0], current_position[1] + 1]
