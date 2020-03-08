extends Node2D

const min_x = 1
const min_y = 1
const max_x = 11
const max_y = 9

onready var tilemap = $PlayArea/Tileset
onready var memory_path = $PlayArea/MemoryPath
onready var player = $PlayArea/Player
onready var memorise_timer = $MemoriseTimer
onready var gameplay_timer = $GameplayTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	memory_path = Generator.generate(memory_path)
	var starting_point = Globals.reverse_line_point(memory_path.get_point_position(0))
	player.current_position = [starting_point.x, starting_point.y]
	tilemap.place_start(starting_point)
	
	memorise_timer.wait_time = 5
	memorise_timer.start()
	
	tilemap.place_end(
		Globals.reverse_line_point(
			memory_path.get_point_position(
				memory_path.get_point_count() - 1
			)
		)
	)


func _process(delta):
	$UIArea/Timer/Seconds.text = str(floor(memorise_timer.time_left))

func _input(event):
	if Input.is_action_just_pressed("ui_select"):
		memory_path.add_point(Vector2(
			(3 * 16) + 8,
			((min_y + 2) * 16) + 8
		))
