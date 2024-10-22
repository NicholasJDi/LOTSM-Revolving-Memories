class_name OptionsMenu
extends Control

@onready var back: Button = $Back


func _on_back_pressed() -> void:
	SignalBus.Emit_Exit_Options_Menu()
	Console.Print("Save", "Output", "save_options_data: %s" % SettingsDataContainer.create_storage_dictionary())
	SaveManager.save_settings_data(SettingsDataContainer.create_storage_dictionary())
	Console.Print("Menu", "Output", "load_main_menu")
