extends Node2D

const min_x = 1
const min_y = 1
const max_x = 11
const max_y = 9

onready var tilemap = $PlayArea/Tileset
onready var memory_path = $PlayArea/MemoryPath

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	memory_path = Generator.generate(memory_path)
	tilemap.place_start(
		Globals.reverse_line_point(
			memory_path.get_point_position(0)
		)
	)
	
	tilemap.place_end(
		Globals.reverse_line_point(
			memory_path.get_point_position(
				memory_path.get_point_count() - 1
			)
		)
	)


func _input(event):
	if Input.is_action_just_pressed("ui_select"):
		memory_path.add_point(Vector2(
			(3 * 16) + 8,
			((min_y + 2) * 16) + 8
		))
