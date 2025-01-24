class_name OptionsMenu
extends Control

@onready var back: Button = $Back
@onready var sound: MarginContainer = $MarginContainer/VBoxContainer/TabContainer/Sound
@onready var tab_container: TabContainer = $MarginContainer/VBoxContainer/TabContainer

func _on_back_pressed() -> void:
	get_parent().On_Options_Menu_Exit()
	tab_container.current_tab = 0
	ConsoleWindow.Print("save_options_data: %s" % SettingsDataContainer.Storage_Dict, "Save", "Output")
	SaveManager.Save_Data(SettingsDataContainer.Storage_Dict, "Settings")
	if get_parent().name == "Main_Menu":
		ConsoleWindow.Print("load_main_menu", "Menu", "Output")
	elif get_parent().name == "Pause_Menu":
		ConsoleWindow.Print("load_pause_menu", "Menu", "Output")
