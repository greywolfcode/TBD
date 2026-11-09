extends Node3D

const center: Vector3 = Vector3.ZERO
var rotation_speed: float = 2.0 
var tilt_speed = deg_to_rad(1.0)
var zoom_speed: float = 5.0
var angle: float = 0.0
var offset: Vector3

@onready var camera: Camera3D = $Camera3D

@export var max_rotation: float = 0.0
@export var min_rotation: float = -60.0

@export var max_zoom: float = 100
@export var min_zoom: float = 40

func _ready() -> void:
	#set camera distance to origin
	offset = global_transform.origin - center


func _process(delta: float) -> void:
	if Input.is_action_pressed("rotate_left"):
		rotate_y(rotation_speed * delta)
	elif Input.is_action_pressed("rotate_right"):
		rotate_y(-1 * rotation_speed * delta)
	
	if Input.is_action_pressed("tilt_up"):
		if camera.rotation_degrees.x < max_rotation:
			camera.rotate_x(tilt_speed)
	elif Input.is_action_pressed("tilt_down"):
		if camera.rotation_degrees.x > min_rotation:
			camera.rotate_x(-1 * tilt_speed)
	
	if Input.is_action_just_pressed("zoom_out"):
		if camera.fov < max_zoom:
			camera.fov += zoom_speed
	elif Input.is_action_just_pressed("zoom_in"):
		if camera.fov > min_zoom:
			camera.fov -= zoom_speed
