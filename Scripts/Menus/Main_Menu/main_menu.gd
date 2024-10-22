extends Control

@onready var options_menu: OptionsMenu = $Options_Menu
@onready var main_menu: MarginContainer = $Main_Menu


func _ready():
	SignalBus.Exit_Options_Menu.connect(On_Options_Menu_Exit)
	Console.Print("Menu", "Output", "load_main_menu")


func On_Options_Menu_Exit():
	main_menu.visible = true
	options_menu.visible = false


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_0.tscn")
	Console.Print("Scene", "Output", "load_level_0")


func _on_options_pressed():
	options_menu.visible = true
	main_menu.visible = false
	Console.Print("Menu", "Output", "load_options_menu")


func _on_quit_pressed():
	Console.Print("Global", "Output", "quit_game")
	get_tree().quit()
