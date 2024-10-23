class_name Settings_Tab_Container
extends Control

@onready var resolution_mode_button: Control = $TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Resolution_Mode_Button
@onready var resolution_slider_x: Control = $TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Resolution_Slider_X
@onready var resolution_slider_y: Control = $TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Resolution_Slider_Y
@onready var custom_resolution_confirm_button: Control = $TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Custom_Resolution_Confirm_Button
@onready var tab_container: TabContainer = $TabContainer

var Resolution_Toggle

func _ready():
	SignalBus.Resolution.connect(Resolution)
	SignalBus.Resolution_Custom.connect(Resolution_Custom)
	resolution_mode_button.visible = SettingsDataContainer.Get_Data("graphics", "window_mode_windowed")


func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_right") or event.is_action_pressed("ui_right"):
		if tab_container.current_tab >= tab_container .get_tab_count() -2:
			tab_container.current_tab = 0
			return
		tab_container.current_tab = tab_container.current_tab + 1
	if event.is_action_pressed("move_left") or event.is_action_pressed("ui_left"):
		if tab_container.current_tab == 0:
			tab_container.current_tab = tab_container .get_tab_count() -2
			return
		tab_container.current_tab = tab_container.current_tab - 1
	if event.is_action_pressed("ui_cancel"):
		SignalBus.Emit_Exit_Options_Menu_External()









func Resolution(value):
	if value:
		resolution_mode_button.visible = true
		Resolution_Toggle = true
	else:
		resolution_mode_button.visible = false
		resolution_slider_x.visible = false
		resolution_slider_y.visible = false
		custom_resolution_confirm_button.visible = false
		Resolution_Toggle = false


func Resolution_Custom(value):
	if value:
		resolution_slider_x.visible = true
		resolution_slider_y.visible = true
		custom_resolution_confirm_button.visible = true
	else:
		resolution_slider_x.visible = false
		resolution_slider_y.visible = false
		custom_resolution_confirm_button.visible = false
