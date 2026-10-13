extends Node

# Also manager the cursor.

var gta_path: String

var mouse_sensitivity:float = 1.0

var _player_camera:OLCamera = null # The main camera of the game. # DebugManager change this camera state to FlyMode when activated

func _ready() -> void:
	if OS.has_feature("editor"):
		gta_path = ProjectSettings.globalize_path("res://gta")
	else:
		gta_path = OS.get_executable_path().get_base_dir()
	print("GTA path: %s" % gta_path)
	NoCaseFS.index(gta_path)
	ModelFS.clear()
	ModelFS.add_directory(gta_path.path_join("models"))
	ModelFS.add_cd_image(gta_path.path_join("models/gta3.img"))
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_tree() -> void:
	ModelFS.clear()

func _process(delta: float) -> void:
	# Change cursor state
	if Input.is_action_just_pressed("debug_show_cursor"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#region CALLS
func is_cursor_visible() -> bool: return Input.mouse_mode == Input.MOUSE_MODE_VISIBLE

func get_player_camera() -> OLCamera: return _player_camera
#endregion
