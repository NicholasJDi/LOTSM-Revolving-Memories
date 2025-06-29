extends Control

@onready var button_new_game: Button = $"Main/New Game"
@onready var button_continue: Button = $Main/Continue
@onready var button_settings: Button = $Main/Settings
@onready var button_badges: Button = $Main/Badges
@onready var button_quit: Button = $Main/Quit


func _on_new_game_pressed() -> void:
	pass # Replace with function body.

func _on_continue_pressed() -> void:
	pass # Replace with function body.

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_badges_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
