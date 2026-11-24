extends Node3D

const center: Vector3 = Vector3.ZERO
var pan_speed: float = 2.0 
var zoom_speed: float = 10.0
var zoom_length: float = 0.2
var zoom_target: float = 1.0
var angle: float = 0.0
var offset: Vector3

@onready var camera: Camera3D = $zoom/Camera3D
@onready var zoom_arm: SpringArm3D = $zoom
@onready var tiles: Node3D = $"../tiles"

@export var max_rotation: float = 0.0
@export var min_rotation: float = -60.0

@export var max_zoom: float = 3
@export var min_zoom: float = -3

func _ready() -> void:
	#set camera distance to origin
	offset = global_transform.origin - center


func _process(delta: float) -> void:
	if Input.is_action_pressed("pan_forwards"):
		tiles.position.z -= pan_speed * delta
	elif Input.is_action_pressed("pan_backwards"):
		tiles.position.z += pan_speed * delta
	
	if Input.is_action_pressed("pan_left"):
		tiles.position.x -= pan_speed * delta
	elif Input.is_action_pressed("pan_right"):
		tiles.position.x += pan_speed * delta
	
	if Input.is_action_just_pressed("zoom_out"):
		if zoom_target < max_zoom:
			zoom_target += zoom_length
	elif Input.is_action_just_pressed("zoom_in"):
		if zoom_target > min_zoom:
			zoom_target -= zoom_length
	
	Globals.grid_offset.x = tiles.position.x
	Globals.grid_offset.z = tiles.position.z
	
	#actually change zoom
	if zoom_target != zoom_arm.spring_length:
		zoom_arm.spring_length = lerp(zoom_arm.spring_length, zoom_target, zoom_speed * delta)
