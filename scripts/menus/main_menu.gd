extends Control

@onready var button_new_game: Button = $"Main/New Game"
@onready var button_continue: Button = $Main/Continue
@onready var button_settings: Button = $Main/Settings
@onready var button_badges: Button = $Main/Badges
@onready var button_quit: Button = $Main/Quit

@onready var badge_menu: Control = $BadgeMenu
@onready var options_menu: Control = $Options_Menu
@onready var main_menu: Control = $Main

@onready var animation_player: AnimationPlayer = $Main/AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	if not GameManager.is_scene_transitioning:
		GlobalUi.show_scene()
	else:
		while GameManager.is_scene_transitioning != false:
			await get_tree().process_frame
	await get_tree().process_frame
	animation_player.play("Main_Menu/Enter_Scene")

func _on_new_game_pressed() -> void:
	animation_player.play("Main_Menu/Exit - New Game")
	await animation_player.animation_finished
	BadgeManager.award_badge("welcome")
	GameManager.transition_to_scene("res://scenes/menus/main_menu.tscn")

func _on_continue_pressed() -> void:
	animation_player.play("Main_Menu/Exit - Continue")
	await animation_player.animation_finished
	animation_player.play("Main_Menu/Enter")

func _on_settings_pressed() -> void:
	animation_player.play("Main_Menu/Exit - Settings")
	await animation_player.animation_finished
	options_menu.enter()

func _on_badges_pressed() -> void:
	animation_player.play("Main_Menu/Exit - Badges")
	await animation_player.animation_finished
	badge_menu.enter()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_menu_exited() -> void:
	animation_player.play("Main_Menu/Enter")


func _on_badge_menu_exited() -> void:
	animation_player.play("Main_Menu/Enter")
