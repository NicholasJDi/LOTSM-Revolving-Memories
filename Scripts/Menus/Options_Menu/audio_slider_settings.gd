class_name Audio_Slider
extends Control

@onready var audio_name: Label = $HBoxContainer/Audio_Name
@onready var audio_num: Label = $HBoxContainer/Audio_Num
@onready var h_slider: HSlider = $HBoxContainer/HSlider

@export var bus_name = ""

var bus_index = 0


func _ready():
	h_slider.value_changed.connect(on_value_changed)
	get_bus_name_by_index()
	load_data()
	set_name_text()
	set_slider_value()


func load_data():
	on_value_changed(SettingsDataContainer.Storage_Dict.sound[index_to_name()])


func index_to_name():
	match bus_index:
		0:
			return "master_volume"
		1:
			return "master_music_volume"
		2:
			return "master_sfx_volume"
		3:
			return "music_menu_volume"
		4:
			return "music_game_volume"
		5:
			return "music_boss_volume"
		6:
			return "sfx_environment_volume"
		7:
			return "sfx_player_volume"

func set_name_text():
	audio_name.text = str(bus_name) + " Volume"


func set_num_text():
	if h_slider.value == 0:
		audio_num.text = "Muted"
	elif h_slider.value == 1:
		audio_num.text = "Max"
	else:
		audio_num.text = str(h_slider.value * 100) + "%"


func get_bus_name_by_index():
	bus_index = AudioServer.get_bus_index(bus_name)


func set_slider_value():
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_num_text()


func on_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_num_text()
	SettingsDataContainer.Storage_Dict.sound[index_to_name()] = value
