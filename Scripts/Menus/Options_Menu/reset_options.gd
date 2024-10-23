extends Control

@onready var tab_container: TabContainer = $"../.."
@onready var timer: Timer = $Timer
@onready var button: Button = $MarginContainer/Label/Button
@onready var button_2: Button = $MarginContainer/Label/Button2

var Last_Selected_Tab = -1
var Confirm_Enabled = false


func _ready():
	SignalBus.Exit_Options_Menu.connect(on_options_menu_exit)


func on_options_menu_exit():
	Confirm_Enabled = false
	tab_container.current_tab = Last_Selected_Tab


func _on_button_pressed():
	Confirm_Enabled = false
	tab_container.current_tab = Last_Selected_Tab


func _on_button_2_pressed():
	if Confirm_Enabled:
		Confirm_Enabled = false
		DirAccess.remove_absolute(SaveManager.Data_Path["Settings"])
		get_tree().quit(0)
		Console.Print("Save", "Output", "reset_options")
		Console.Print("Global", "Output", "quit_game")


func _on_tab_container_tab_selected(tab: int):
	if tab == 4:
		var button_timer = 6
		timer.start(1)
		button_timer = button_timer - 1
		button_2.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		timer.start(1)
		button_timer = button_timer - 1
		button_2.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		timer.start(1)
		button_timer = button_timer - 1
		button_2.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		timer.start(1)
		button_timer = button_timer - 1	
		button_2.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		timer.start(1)
		button_timer = button_timer - 1
		button_2.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		button_2.text = "Confirm"
		Confirm_Enabled = true
	else:
		Confirm_Enabled = false


func _on_tab_container_tab_hovered(tab: int) -> void:
	if tab == 4:
		if tab_container.current_tab != 4:
			Last_Selected_Tab = tab_container.current_tab
