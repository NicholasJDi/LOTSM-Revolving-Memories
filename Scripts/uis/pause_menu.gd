class_name PauseMenu
extends ColorRect

@onready var main_ui: MarginContainer = $"../Main_UI"
@onready var menu: PanelContainer = $Menu
@onready var options_menu: OptionsMenu = $Options_Menu

@onready var save: Button = $Menu/MarginContainer/VBoxContainer/Save
@onready var timer: Timer = $Timer


func _ready() -> void:
	SignalBus.Exit_Options_Menu.connect(On_Options_Menu_Exit)

func pause() -> void:
	if not get_parent().get_parent().get_parent().invincible:
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
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()


func _on_resume_pressed() -> void:
	resume()

func _on_options_pressed() -> void:
	options_menu.visible = true
	menu.visible = false
	ConsoleWindow.Print("load_options_menu", "Menu", "Output")

func _on_save_pressed() -> void:
	SaveManager.Save_File_Save(SettingsDataContainer.save_file_data.data, SettingsDataContainer.save_file_data.file.location)
	save.text = "Saved!"
	timer.start(1)
	await timer.timeout
	save.text = "Save"

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/Main_Menu.tscn")
