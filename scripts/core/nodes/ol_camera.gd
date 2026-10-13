extends Camera3D
class_name OLCamera # Open Liberty Camera

enum CameraMode {
	PLAYER_MODE,
	FLY_MODE,
	CUTSCENE_MODE
}

@export var initial_mode:CameraMode = CameraMode.PLAYER_MODE

var node_owner:Node3D = null
var default_local_transform:Transform3D

var current_camera_mode:CameraMode = CameraMode.PLAYER_MODE
var current_fly_mode_speed:float = 30.0

#region GODOT FUNCTIONS
func _ready() -> void:
	node_owner = get_parent()
	default_local_transform = transform
	set_camera_mode.call_deferred(initial_mode)

func _input(event: InputEvent) -> void:
	if current_camera_mode != CameraMode.FLY_MODE or GameManager.is_cursor_visible():
		return
	
	if event is InputEventMouseMotion:
		rotation.y += deg_to_rad(-event.relative.x * GameManager.mouse_sensitivity)
		rotation.x = clampf( rotation.x + deg_to_rad(-event.relative.y * GameManager.mouse_sensitivity), -PI / 2.0, PI / 2.0 )
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_fly_mode_speed *= 1.25
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_fly_mode_speed /= 1.25

func _physics_process(delta: float) -> void:
	handle_camera_mode(delta)
#endregion 

#region CALLS
func handle_camera_mode(_delta:float) -> void:
	match current_camera_mode:
		CameraMode.PLAYER_MODE:
			pass
		CameraMode.FLY_MODE:
			if GameManager.is_cursor_visible(): return # Why? idk. We can cut it later
			
			top_level = true
			var input_dir = Vector3(
				Input.get_action_strength("flycam_right") - Input.get_action_strength("flycam_left"),
				0,
				Input.get_action_strength("flycam_backward") - Input.get_action_strength("flycam_forward")
			)
			
			var vertical_input := Input.get_action_strength("flycam_up") - Input.get_action_strength("flycam_down")
			var move_dir:Vector3 = (global_transform.basis * input_dir).normalized()
			
			var speed_multiplier := 2.0 if Input.is_key_pressed(KEY_SHIFT) else 1.0
			global_position += move_dir * current_fly_mode_speed * speed_multiplier * _delta
		CameraMode.CUTSCENE_MODE:
			pass

func reset_camera() -> void:
	top_level = false
	reparent(node_owner, false)
	transform = default_local_transform

func set_camera_mode(_mode:CameraMode) -> void:
	current_camera_mode = _mode
	
	match current_camera_mode:
		CameraMode.PLAYER_MODE:
			reset_camera()
		CameraMode.FLY_MODE:
			top_level = true
			reparent(get_tree().root)
		CameraMode.CUTSCENE_MODE:
			reset_camera()
#endregion
