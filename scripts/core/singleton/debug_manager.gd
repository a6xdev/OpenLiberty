extends Node

enum DebugMode {
	ENABLED,
	DISABLED
}

var current_mode:DebugMode = DebugMode.DISABLED

signal debug_mode_changed(_mode:DebugMode)

#region GODOT FUNCTION
func _process(delta: float) -> void:
	# Enable or disable debug mode.
	if Input.is_action_just_pressed("change_debug_mode"):
		var value:DebugMode = DebugMode.DISABLED if current_mode == DebugMode.ENABLED else DebugMode.ENABLED
		set_debug_mode(value)
	
	if current_mode == DebugMode.ENABLED:
		handle_debug_input()
#endregion

#region CALLS
func handle_debug_input() -> void:
	if Input.is_action_just_pressed("debug_fly_mode"):
		var camera:OLCamera = GameManager.get_player_camera()
		#var is_in_cutscene_mode:bool = camera.current_camera_mode == OLCamera.CameraMode.CUTSCENE_MODE
		var value = OLCamera.CameraMode.FLY_MODE if camera.current_camera_mode != OLCamera.CameraMode.FLY_MODE else OLCamera.CameraMode.PLAYER_MODE
		camera.set_camera_mode(value)

func set_debug_mode(_mode:DebugMode) -> void:
	current_mode = _mode
	debug_mode_changed.emit(current_mode)
	
	match current_mode:
		DebugMode.DISABLED:
			GameManager.get_player_camera().set_camera_mode(OLCamera.CameraMode.PLAYER_MODE)

func is_debug_enabled() -> bool:
	return current_mode == DebugMode.ENABLED
#endregion
