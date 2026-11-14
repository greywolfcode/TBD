extends Control

var default_x: int = 0
var default_y: int = 0
var tiles: Dictionary[Vector2, Globals.TileType] = {}

const FOREST: PackedScene = preload("res://tiles/forest/forest.tscn")
const MEADOW: PackedScene = preload("res://tiles/meadow/meadow.tscn")
const MOUTAIN: PackedScene = preload("res://tiles/mountain/mountain.tscn")
const WATER: PackedScene = preload("res://tiles/water/water.tscn")


func _on_card_button_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(self.position.x, default_y - 336), 0.5) #move up 1 card length

func _on_card_button_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(default_x, default_y), 0.5)

func _on_card_button_button_down() -> void:
	Globals.game_state = Globals.GameState.PLACING_TILE
	var preview: Node = get_node("/root/game/table/tile_preview")
	match tiles[Vector2(0, 0)]:
		Globals.TileType.FOREST:
			preview.add_child(FOREST.instantiate())
			preview.type = Globals.TileType.FOREST
		Globals.TileType.MEADOW:
			preview.add_child(MEADOW.instantiate())
			preview.type = Globals.TileType.MEADOW
		Globals.TileType.MOUNTAIN:
			preview.add_child(MOUTAIN.instantiate())
			preview.type = Globals.TileType.MOUNTAIN
		Globals.TileType.WATER:
			preview.add_child(WATER.instantiate())
			preview.type = Globals.TileType.WATER

func set_card_name(name: String) -> void:
	$card_button/name.text = name

func set_card_default_pos(x: int, y: int) -> void:
	default_x = x
	default_y = y
	
	self.position.x = default_x
	self.position.y = default_y
