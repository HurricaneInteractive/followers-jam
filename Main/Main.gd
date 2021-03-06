extends Node2D

enum States {
	NEW_LEVEL,
	MEMORISE,
	GAMEPLAY,
	FAIL,
	WIN
}

var current_state = States.NEW_LEVEL
var score: int = 0
var high_score: int = 0

var medium_threshold = 5
var hard_threshold = 10

var memorise_interval: int = 5
var gameplay_interval: int = 10

onready var memorise_timer = $MemoriseTimer
onready var gameplay_timer = $GameplayTimer
onready var timer_seconds = $UIArea/UIWrap/TimeValue
onready var memory_path = $PlayArea/MemoryPath
onready var player_path = $PlayArea/PlayerPath
onready var tilemap = $PlayArea/Tileset
onready var player = $PlayArea/Player
onready var score_value = $UIArea/UIWrap/ScoreValue
onready var outcome = $PlayArea/Outcome
onready var hight_score_text = $UIArea/UIWrap/MarginContainer/HS

# triggers when state is changed to NEW_LEVEL
func on_change_to_new_level() -> void:
	outcome.visible = false
	player_path.visible = false
	memory_path.visible = false
	player.visible = false
	
	memory_path.clear_points()
	player_path.clear_points()
	tilemap.clear_tileset()
	
	score_value.text = str(score)
	
	if score >= medium_threshold and score < hard_threshold:
		Globals.change_difficulty(Globals.Difficulty.MEDIUM)
	elif score >= hard_threshold:
		Globals.change_difficulty(Globals.Difficulty.HARD)

# triggers when state is changed to MEMORISE
func on_change_to_memorise() -> void:
	memorise_timer.wait_time = memorise_interval
	memory_path = Generator.generate(memory_path)
	var starting_point = Globals.reverse_line_point(memory_path.get_point_position(0))
	player.current_position = [starting_point[0], starting_point[1]]
	player_path.add_point(Globals.get_line_point(starting_point[0], starting_point[1]))

	tilemap.place_start(starting_point)
	tilemap.place_end(
		Globals.reverse_line_point(
			memory_path.get_point_position(
				memory_path.get_point_count() - 1
			)
		)
	)

	memory_path.visible = true
	memorise_timer.start()

# triggers when state is changed to GAMEPLAY
func on_change_to_gameplay() -> void:
	memorise_timer.stop()
	memory_path.visible = false
	player.can_move = true
	player.visible = true
	gameplay_timer.wait_time = gameplay_interval
	
	gameplay_timer.start()

# triggers when state is changed to FAIL
func on_change_to_fail() -> void:
	gameplay_timer.stop()
	outcome.get_node("OutcomeText").text = "OOPS!"
	outcome.visible = true
	player.can_move = false
	if score > high_score:
		high_score = score
		hight_score_text.text = str(high_score)
	score = 0
	Globals.change_difficulty(Globals.Difficulty.EASY)
	memory_path.visible = true
	player_path.visible = true

# triggers when state is changed to WIN
func on_change_to_win() -> void:
	gameplay_timer.stop()
	outcome.get_node("OutcomeText").text = "NICE!"
	outcome.visible = true
	player.can_move = false
	score += 1

# method to change the state of the game
func change_game_state(state: int) -> void:
	current_state = state
	match current_state:
		States.NEW_LEVEL:
			on_change_to_new_level()
		States.MEMORISE:
			on_change_to_memorise()
		States.GAMEPLAY:
			on_change_to_gameplay()
		States.FAIL:
			on_change_to_fail()
		States.WIN:
			on_change_to_win()

# ready method
func _ready():
	change_game_state(States.NEW_LEVEL)

# process method
func _process(delta):
	match current_state:
		States.NEW_LEVEL:
			timer_seconds.text = "--"
		States.MEMORISE:
			timer_seconds.text = str(round(memorise_timer.time_left))
		States.GAMEPLAY:
			timer_seconds.text = str(round(gameplay_timer.time_left))
			var player_current_length = player_path.get_point_count()
			var memory_current_length = memory_path.get_point_count()
			var player_last_point = player_path.get_point_position(player_current_length - 1)
			var memory_point = memory_path.get_point_position(memory_current_length - 1)
			
			if player_last_point[0] == memory_point[0] and player_last_point[1] == memory_point[1]:
				change_game_state(States.WIN)

func _input(event):
	if Input.is_action_just_pressed("ui_select"):
		if current_state == States.NEW_LEVEL:
			change_game_state(States.MEMORISE)
		if current_state == States.FAIL or current_state == States.WIN:
			change_game_state(States.NEW_LEVEL)

# When the memorise timer runs out
func _on_MemoriseTimer_timeout():
	change_game_state(States.GAMEPLAY)

# When the gameplay timer runs out
func _on_GameplayTimer_timeout():
	change_game_state(States.FAIL)

# When the players position changes
func _on_Player_position_changed(cur_position):
	player_path.add_point(Globals.get_line_point(cur_position[0], cur_position[1]))
	var current_length = player_path.get_point_count()
	var player_last_point = player_path.get_point_position(current_length - 1)
	var memory_point = memory_path.get_point_position(current_length - 1)
	
	if player_last_point[0] != memory_point[0] or player_last_point[1] != memory_point[1]:
		change_game_state(States.FAIL)
