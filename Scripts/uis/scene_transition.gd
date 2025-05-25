extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func exit() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	return
