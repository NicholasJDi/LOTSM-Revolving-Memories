class_name PauseMenu
extends ColorRect

@onready var main_ui: MarginContainer = $"../Main_UI"
@onready var menu: PanelContainer = $Menu
@onready var options_menu: OptionsMenu = $Options_Menu

func _ready() -> void:
	SignalBus.Exit_Options_Menu.connect(On_Options_Menu_Exit)

func pause() -> void:
	get_tree().paused = true
	self.show()
	main_ui.hide()

func resume() -> void:
	get_tree().paused = false
	main_ui.show()
	self.hide()

func On_Options_Menu_Exit():
	menu.visible = true
	options_menu.visible = false

func _process(_delta: float) -> void:
	if not get_window().has_focus() and Global.unfocused_pause:
		pause()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed() -> void:
	resume()


func _on_options_pressed() -> void:
	options_menu.visible = true
	menu.visible = false
	ConsoleWindow.Print("Menu", "Output", "load_options_menu")


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/Main_Menu.tscn")
