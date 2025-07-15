extends Control

@export var Parent : Control

@onready var fullscreen: CheckButton = $VBoxContainer/Fullscreen
@onready var borderless: CheckButton = $VBoxContainer/Borderless

func _ready() -> void:
	await get_tree().create_timer(.1).timeout
	if Parent.config_file.has_section_key("Graphics", "Fullscreen"):
		fullscreen.button_pressed = Parent.config_file.get_value("Graphics", "Fullscreen")
		Set_Fullscreen(Parent.config_file.get_value("Graphics", "Fullscreen"))
	if Parent.config_file.has_section_key("Graphics", "Borderless"):
		borderless.button_pressed = Parent.config_file.get_value("Graphics", "Borderless")
		Set_Borderless(Parent.config_file.get_value("Graphics", "Borderless"))

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	Set_Fullscreen(toggled_on)


func _on_borderless_toggled(toggled_on: bool) -> void:
	Set_Borderless(toggled_on)


func Set_Fullscreen(enabled : bool):
	if enabled:
		borderless.hide()
		Set_Borderless(false)
		borderless.button_pressed = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		borderless.show()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Parent.config_file.set_value("Graphics", "Fullscreen", enabled)

func Set_Borderless(enabled : bool):
	if enabled:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	Parent.config_file.set_value("Graphics", "Borderless", enabled)
