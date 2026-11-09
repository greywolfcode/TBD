extends Node3D

const center: Vector3 = Vector3.ZERO
var rotation_speed: float = 2.0 
var angle: float = 0.0
var offset: Vector3

func _ready() -> void:
	#set camera distance to origin
	offset = global_transform.origin - center


func _process(delta: float) -> void:
	if Input.is_action_pressed("rotate_left"):
		rotate_y(rotation_speed * delta)
	elif Input.is_action_pressed("rotate_right"):
		rotate_y(-1 * rotation_speed * delta)
	
