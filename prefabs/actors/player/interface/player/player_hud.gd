extends CanvasLayer

@onready var actor_player: Player = $".."

@onready var ui_debug: Control = $ui_debug

func _ready() -> void:
	ui_debug.hide()
	
	DebugManager.debug_mode_changed.connect(_on_debug_mode_changed)

func _process(delta: float) -> void:
	$ui_debug/Vbox/player_pos.text = "Player Pos: " + str(actor_player.global_position)

#region SIGNALS
func _on_debug_mode_changed(_mode:DebugManager.DebugMode) -> void:
	match _mode:
		DebugManager.DebugMode.ENABLED:
			ui_debug.show()
		DebugManager.DebugMode.DISABLED:
			ui_debug.hide()
#endregion
