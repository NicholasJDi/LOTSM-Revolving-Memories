extends Control

@onready var label_num: Label = $HBoxContainer/Label_Num
@onready var h_slider: HSlider = $HBoxContainer/HSlider


func _ready():
	h_slider.value = SettingsDataContainer.Get_Data("graphics", "resolution_custom_x")
	label_num.text = str(SettingsDataContainer.Get_Data("graphics", "resolution_custom_x"))
	SignalBus.Resolution_Custom_Confirm.connect(Resolution_Custom_Confirm)
	h_slider.value_changed.connect(On_Value_Changed)


func Resolution_Custom_Confirm():
	SettingsDataContainer.set_graphics(3, h_slider.value)
	SignalBus.Emit_Resolution_Custom_X(h_slider.value)


func On_Value_Changed(value):
	label_num.text = str(h_slider.value)
