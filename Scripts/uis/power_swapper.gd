extends ColorRect

@onready var Player = $"..".get_parent().get_parent()
@onready var main_ui: MarginContainer = $"../Main_UI"
@onready var pause_menu: PauseMenu = $"../Pause_Menu"

var shortcutted : bool


func _process(_delta: float) -> void:
	if Input.is_action_pressed("swap_powers"):
		if Input.is_action_just_pressed("swap_powers+1"):
			Player.current_power_set = 1
			SettingsDataContainer.save_file_data.data.player.powers = 1
			ConsoleWindow.Print("Power Set Swapped To 1", "Player")
			shortcutted = true
		if Input.is_action_just_pressed("swap_powers+2"):
			Player.current_power_set = 2
			SettingsDataContainer.save_file_data.data.player.powers = 2
			ConsoleWindow.Print("Power Set Swapped To 2", "Player")
			shortcutted = true
		if Input.is_action_just_pressed("swap_powers+3"):
			Player.current_power_set = 3
			SettingsDataContainer.save_file_data.data.player.powers = 3
			ConsoleWindow.Print("Power Set Swapped To 3", "Player")
			shortcutted = true
		if Input.is_action_just_pressed("swap_powers+4"):
			Player.current_power_set = 4
			SettingsDataContainer.save_file_data.data.player.powers = 4
			ConsoleWindow.Print("Power Set Swapped To 4", "Player")
			shortcutted = true
		if Input.is_action_just_pressed("swap_powers+5"):
			Player.current_power_set = 5
			SettingsDataContainer.save_file_data.data.player.powers = 5
			ConsoleWindow.Print("Power Set Swapped To 5", "Player")
			shortcutted = true
		if Input.is_action_just_pressed("swap_powers+6"):
			Player.current_power_set = 6
			SettingsDataContainer.save_file_data.data.player.powers = 6
			ConsoleWindow.Print("Power Set Swapped To 6", "Player")
			shortcutted = true
	if Input.is_action_just_released("swap_powers") and not pause_menu.visible:
		if not shortcutted:
			visible = !visible
			main_ui.visible = !main_ui.visible
		else:
			shortcutted = false
	if Input.is_action_just_pressed("pause") and not pause_menu.visible and visible:
		main_ui.show()
		hide()
