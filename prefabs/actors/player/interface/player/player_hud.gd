extends CanvasLayer

@onready var actor_player: Player = $".."

func _process(delta: float) -> void:
	$ui_debug/player_pos.text = "Player Pos: " + str(actor_player.global_position)
