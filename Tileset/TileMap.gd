extends TileMap

var _tileset
const min_x = 1
const min_y = 1
const max_x = 11
const max_y = 9

# Called when the node enters the scene tree for the first time.
func _ready():
	_tileset = get_tileset()


func get_start_tile() -> int:
	return _tileset.find_tile_by_name("Start")


func get_end_tile() -> int:
	return _tileset.find_tile_by_name("Start")


func place_start(at: Vector2) -> void:
	set_cellv(at, get_start_tile())


func place_end(at: Vector2) -> void:
	set_cellv(at, get_end_tile())


func clear_tileset() -> void:
	self.clear()
