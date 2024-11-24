class_name OptionsMenu
extends Control

@onready var back: Button = $Back

func _ready() -> void:
	SignalBus.Exit_Options_Menu_External.connect(exit)


func _on_back_pressed() -> void:
	exit()

func exit():
	SignalBus.Emit_Exit_Options_Menu()
	ConsoleWindow.Print("save_options_data: %s" % SettingsDataContainer.Storage_Dict, "Save", "Output")
	SaveManager.Save_Data(SettingsDataContainer.Storage_Dict, "Settings")
	if get_parent().name == "Main_Menu":
		ConsoleWindow.Print("load_main_menu", "Menu", "Output")
	elif get_parent().name == "Pause_Menu":
		ConsoleWindow.Print("load_pause_menu", "Menu", "Output")
