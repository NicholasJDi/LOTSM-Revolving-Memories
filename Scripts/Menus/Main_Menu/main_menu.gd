extends Control

@onready var options_menu: OptionsMenu = $Options_Menu
@onready var play_menu: PlayMenu = $Play_Menu
@onready var main_menu: MarginContainer = $Main_Menu


func _ready():
	SignalBus.Exit_Options_Menu.connect(On_Options_Menu_Exit)
	SignalBus.Exit_Play_Menu.connect(On_Play_Menu_Exit)
	ConsoleWindow.Print("load_main_menu", "Menu", "Output")


func On_Options_Menu_Exit():
	main_menu.visible = true
	options_menu.visible = false

func On_Play_Menu_Exit():
	main_menu.visible = true
	play_menu.visible = false
	ConsoleWindow.Print("load_main_menu", "Menu", "Output")


func _on_play_pressed():
	play_menu.visible = true
	main_menu.visible = false
	ConsoleWindow.Print("load_play_menu", "Menu", "Output")

func _on_options_pressed():
	options_menu.visible = true
	main_menu.visible = false
	ConsoleWindow.Print("load_options_menu", "Menu", "Output")

func _on_quit_pressed():
	ConsoleWindow.Print("quit_game", "Global", "Output")
	get_tree().quit()
