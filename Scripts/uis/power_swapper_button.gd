extends Button

@onready var player: CharacterBody2D = $"../../../../..".get_parent().get_parent()
@onready var power_swapper: ColorRect = $"../../../.."
@onready var main_ui: MarginContainer = $"../../../../../Main_UI"

func _ready() -> void:
	if name == "0" and SettingsDataContainer.save_file_data.data.player.level == "dev":
		$"../../..".show()

func _pressed() -> void:
	get_tree().paused = false
	player.current_power_set = int(str(name))
	SettingsDataContainer.save_file_data.data.player.powers = int(str(name))
	ConsoleWindow.Print("Power Set Swapped To " + name, "Player")
	power_swapper.hide()
	main_ui.show()
