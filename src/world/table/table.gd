extends Node3D

const RAY_LENGTH: int = 50
@onready var preview: Node3D = $tile_preview

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preview.hide()
	preview.position.y = 0.5

func _physics_process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var cam = $"../camara/zoom/Camera3D"
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	
	if result:
		var grid_x = floor(result.position.x)
		var grid_z = floor(result.position.z)
		
		preview.position.x = grid_x
		preview.position.z = grid_z
		
		preview.show()
	else:
		preview.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
