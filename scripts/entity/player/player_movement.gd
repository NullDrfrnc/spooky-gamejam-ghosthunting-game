extends Node3D
class_name PlayerMovement

@export var walk_speed: float = 12
@export var sprint_speed: float = 18
@export var crouch_speed: float = 4

@export var acceleration: float = 50;
@export var deceleration: float = 100;

@export var camera_sensitivity: float = 1
@export var camera_max_degrees: float = 75;

@onready var player
@onready var camera

func _physics_process(delta: float) -> void:
	self._handle_player_move(delta)

func _handle_player_move(delta: float) -> void:
	var target_velocity = Vector3.ZERO
	
	# Get input vector
	var input_dir = Input.get_vector("mv_left", "mv_right", "mv_foreward", "mv_backward")
	# Calculate move direction based on current facing
	var move_dir = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	target_velocity.x = move_dir.x * _current_move_speed()
	target_velocity.z = move_dir.z * _current_move_speed()
	
	if !player.is_on_floor():
		target_velocity.y -= World.fall_acceleration;
	
	if input_dir.length() > 0:
		player.velocity = player.velocity.move_toward(target_velocity, acceleration * delta)
	else:
		player.velocity = player.velocity.move_toward(target_velocity, deceleration * delta)
	
	
	player.move_and_slide()

# Camera movement from Bramwell on yt
# https://youtu.be/v4IEPi1c0eE?si=v0cpUg0muRM57SSs
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			player.rotate_y(-event.relative.x * (camera_sensitivity / 1000))
			camera.rotate_x(-event.relative.y * (camera_sensitivity / 1000))
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-camera_max_degrees), deg_to_rad(camera_max_degrees))

func _current_move_speed() -> float:
	if _is_crouching():
		return crouch_speed
	
	if _is_sprinting():
		return sprint_speed
	
	return walk_speed

func _is_sprinting() -> bool:
	return (Input.is_action_pressed("mv_sprint") and !_is_crouching())

func _is_crouching() -> bool:
	return Input.is_action_pressed("mv_crouch")
