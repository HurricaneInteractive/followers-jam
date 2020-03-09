extends Node2D

signal position_changed

var current_position = []
var can_move = false

func _process(delta):
	if len(current_position) > 0:
		var new_position = Globals.get_line_point(current_position[0], current_position[1])
		self.position = self.position.linear_interpolate(new_position, 15 * delta)


func _input(event):
	if can_move:
		if Input.is_action_just_pressed("ui_right"):
			if current_position[0] != Globals.max_x:
				current_position = [current_position[0] + 1, current_position[1]]
				emit_signal("position_changed", current_position)
		if Input.is_action_just_pressed("ui_left"):
			if current_position[0] != Globals.min_x:
				current_position = [current_position[0] - 1, current_position[1]]
				emit_signal("position_changed", current_position)
		if Input.is_action_just_pressed("ui_down"):
			if current_position[1] != Globals.max_y:
				current_position = [current_position[0], current_position[1] + 1]
				emit_signal("position_changed", current_position)
