extends CanvasLayer

@onready var transition_rect: ColorRect = $TransitionRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fade_out_scene(time : float = 1):
	animation_player.speed_scale = 1 / time
	animation_player.play("fade_out")
	await animation_player.animation_finished
	animation_player.speed_scale = 1

func fade_in_scene(time : float = 1):
	animation_player.speed_scale = 1 / time
	animation_player.play("fade_in")
	await animation_player.animation_finished
	animation_player.speed_scale = 1


func hide_scene():
	transition_rect.color = "000000"

func show_scene():
	transition_rect.color = "00000000"
