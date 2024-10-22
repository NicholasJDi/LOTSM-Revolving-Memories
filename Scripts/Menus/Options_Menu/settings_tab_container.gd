extends Control

@onready var resolution_mode_button: Control = $TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Resolution_Mode_Button
@onready var resolution_slider_x: Control = $TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Resolution_Slider_X
@onready var resolution_slider_y: Control = $TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Resolution_Slider_Y
@onready var custom_resolution_confirm_button: Control = $TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Custom_Resolution_Confirm_Button

var Resolution_Toggle

func _ready():
	SignalBus.Resolution.connect(Resolution)
	SignalBus.Resolution_Custom.connect(Resolution_Custom)
	resolution_mode_button.visible = SettingsDataContainer.get_window_mode_windowed()


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
