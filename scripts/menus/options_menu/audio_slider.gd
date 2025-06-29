extends Control

@export var Parent : Control

@export var Bus : String

@onready var label: Label = $HBoxContainer/Label
@onready var label_2: Label = $HBoxContainer/Label2
@onready var h_slider: HSlider = $HBoxContainer/HSlider

func _ready() -> void:
	if Parent.config_file.has_section_key("Audio", Bus):
		h_slider.value = Parent.config_file.get_value("Audio", Bus)
		Set_Volume(Parent.config_file.get_value("Audio", Bus))
	label.text = Bus + " Volume"

func _on_h_slider_value_changed(value: float) -> void:
	Set_Volume(h_slider.value)

func Set_Volume(Value):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(Bus), Value / 100)
	Parent.config_file.set_value("Audio", Bus, Value)
	if Value == 0.0:
		label_2.text = "Muted"
	elif Value == 100.0:
		label_2.text = "Max"
	else:
		label_2.text = str(int(Value)) + "%"
