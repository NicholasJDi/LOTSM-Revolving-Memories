class_name OptionsMenu
extends Control

@onready var back: Button = $Back

func _ready() -> void:
	SignalBus.Exit_Options_Menu_External.connect(exit)


func _on_back_pressed() -> void:
	SignalBus.Emit_Exit_Options_Menu()
	ConsoleWindow.Print("Save", "Output", "save_options_data: %s" % SettingsDataContainer.Storage_Dict)
	SaveManager.Save_Data(SettingsDataContainer.Storage_Dict, "Settings")
	ConsoleWindow.Print("Menu", "Output", "load_main_menu")

func exit():
	SignalBus.Emit_Exit_Options_Menu()
	ConsoleWindow.Print("Save", "Output", "save_options_data: %s" % SettingsDataContainer.Storage_Dict)
	SaveManager.Save_Data(SettingsDataContainer.Storage_Dict,"Settings")
	ConsoleWindow.Print("Menu", "Output", "load_main_menu")
