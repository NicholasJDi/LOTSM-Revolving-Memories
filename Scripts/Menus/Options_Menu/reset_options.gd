class_name ResetOptions
extends Control

@export var tab_container: TabContainer = null
@onready var timer: Timer = $Timer
@onready var cancel: Button = $MarginContainer/Control/Label/Cancel
@onready var confirm: Button = $MarginContainer/Control/Label/Confirm

var Last_Selected_Tab = -1
var Confirm_Enabled = false


func _ready():
	SignalBus.Exit_Options_Menu.connect(on_options_menu_exit)

func on_options_menu_exit():
	last()

func _on_button_pressed():
	last()

func last():
	Confirm_Enabled = false
	if Last_Selected_Tab == -1:
		Last_Selected_Tab = tab_container.get_previous_tab()
	tab_container.current_tab = Last_Selected_Tab

func _on_button_2_pressed():
	if Confirm_Enabled:
		Confirm_Enabled = false
		DirAccess.remove_absolute(SaveManager.Data_Path["Settings"])
		get_tree().quit(0)
		ConsoleWindow.Print("reset_options", "Save", "Output")
		ConsoleWindow.Print("quit_game", "Global", "Output")


func _on_tab_selected(tab: int) -> void:
	if tab == 3:
		var button_timer = 6
		timer.start(1)
		button_timer = button_timer - 1
		confirm.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		timer.start(1)
		button_timer = button_timer - 1
		confirm.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		timer.start(1)
		button_timer = button_timer - 1
		confirm.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		timer.start(1)
		button_timer = button_timer - 1	
		confirm.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		timer.start(1)
		button_timer = button_timer - 1
		confirm.text = "Wait " + str(button_timer) + ".."
		await  timer.timeout
		confirm.text = "Confirm"
		Confirm_Enabled = true
	else:
		Confirm_Enabled = false

func _on_tab_hovered(_tab: int) -> void:
	if tab_container.current_tab != 3:
		Last_Selected_Tab = tab_container.current_tab
