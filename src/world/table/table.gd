extends Node3D

const RAY_LENGTH: int = 50
@onready var preview: Node3D = $tile_preview
@onready var tile_storage: Node = $"../tiles"

var was_unpressed = false #tracks if mouse has been unclicked

const FOREST_TILE: PackedScene = preload("res://tiles/forest/forest.tscn")
const MEADOW_TILE: PackedScene = preload("res://tiles/meadow/meadow.tscn")
const MOUTAIN_TILE: PackedScene = preload("res://tiles/mountain/mountain.tscn")
const WATER_TILE: PackedScene = preload("res://tiles/water/water.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preview.hide()
	preview.position.y = 0

func _physics_process(delta: float) -> void:
	if Globals.game_state == Globals.GameState.PLACING_TILE:
		var space_state = get_world_3d().direct_space_state
		var cam = $"../camara/zoom/Camera3D"
		var mousepos = get_viewport().get_mouse_position()

		var origin = cam.project_ray_origin(mousepos)
		var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true

		var result = space_state.intersect_ray(query)
		
		if result:
			var grid_x = floor(result.position.x / 0.05) * 0.05
			var grid_z = floor(result.position.z / 0.05) * 0.05
			
			preview.position.x = grid_x
			preview.position.z = grid_z
			
			preview.show()
		else:
			preview.hide()

func _input(event: InputEvent) -> void:
	if Globals.game_state == Globals.GameState.PLACING_TILE:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if not event.pressed:
				was_unpressed = true

func _process(delta: float) -> void:
	if Globals.game_state == Globals.GameState.PLACING_TILE:
		if Input.is_action_pressed("left_click"):
			#make sure player doesn't instantly place tile if mouse is held down
			if was_unpressed:
				Globals.tiles[Vector2(preview.position.x, preview.position.y)] = Globals.TileType.MEADOW
				
				var new_tile: Node
				match preview.type:
					Globals.TileType.FOREST:
						new_tile = FOREST_TILE.instantiate()
					Globals.TileType.MEADOW:
						new_tile = MEADOW_TILE.instantiate()
					Globals.TileType.MOUNTAIN:
						new_tile = MOUTAIN_TILE.instantiate()
					Globals.TileType.WATER:
						new_tile = WATER_TILE.instantiate()
				
				new_tile.position.x = preview.position.x
				new_tile.position.y = 0.015
				new_tile.position.z = preview.position.z
				tile_storage.add_child(new_tile)
				Globals.game_state = Globals.GameState.SELECTING_CARD
				
				was_unpressed = false
