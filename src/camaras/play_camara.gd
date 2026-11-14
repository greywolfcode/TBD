extends Node3D

const center: Vector3 = Vector3.ZERO
var rotation_speed: float = 2.0 
var tilt_speed = deg_to_rad(1.0)
var zoom_speed: float = 10.0
var zoom_length: float = 0.2
var zoom_target: float = 1.0
var angle: float = 0.0
var offset: Vector3

@onready var camera: Camera3D = $zoom/Camera3D
@onready var zoom_arm: SpringArm3D = $zoom

@export var max_rotation: float = 0.0
@export var min_rotation: float = -60.0

@export var max_zoom: float = 3
@export var min_zoom: float = -3

func _ready() -> void:
	#set camera distance to origin
	offset = global_transform.origin - center


func _process(delta: float) -> void:
	if Input.is_action_pressed("rotate_left"):
		rotate_y(rotation_speed * delta)
	elif Input.is_action_pressed("rotate_right"):
		rotate_y(-1 * rotation_speed * delta)
	
	if Input.is_action_pressed("tilt_up"):
		if zoom_arm.rotation_degrees.x < max_rotation:
			zoom_arm.rotate_x(tilt_speed)
	elif Input.is_action_pressed("tilt_down"):
		if zoom_arm.rotation_degrees.x > min_rotation:
			zoom_arm.rotate_x(-1 * tilt_speed)
	
	if Input.is_action_just_pressed("zoom_out"):
		if zoom_target < max_zoom:
			zoom_target += zoom_length
	elif Input.is_action_just_pressed("zoom_in"):
		if zoom_target > min_zoom:
			zoom_target -= zoom_length
	
	#actually change zoom
	if zoom_target != zoom_arm.spring_length:
		zoom_arm.spring_length = lerp(zoom_arm.spring_length, zoom_target, zoom_speed * delta)
