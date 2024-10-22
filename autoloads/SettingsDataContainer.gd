extends Node

@onready var DEFAULT_SETTINGS : DefaultSettingsResource = preload("res://Resources/Settings/DefaultSettings.tres")


# Sound
var master_volume : float = 0.0
var master_music_volume : float = 0.0
var master_sfx_volume : float = 0.0
var music_menu_volume : float = 0.0
var music_game_volume : float = 0.0
var music_boss_volume : float = 0.0
var sfx_environment_volume : float = 0.0
var sfx_player_volume : float = 0.0
# Controls
var move_left
var move_right
var crouch
var jump
var interact
# Accsesability
# Graphics
var window_mode_index : int = 0
var window_mode_windowed : bool = false
var resolution_custom_x : float = DefaultSettingsResource.DEFAULT_RESOLUTION_CUSTOM_X
var resolution_custom_y : float = DefaultSettingsResource.DEFAULT_RESOLUTION_CUSTOM_Y

var loaded_settings_data : Dictionary = {}


func _ready():
	create_storage_dictionary()


func create_storage_dictionary() -> Dictionary:
	var settings_container_dict : Dictionary = {
		"sound" : create_sound_dict(),
		"accsesability" : create_accsesability_dict(),
		"controls" : create_controls_dict(),
		"graphics" : create_graphics_dict()
	}
	return settings_container_dict


func create_sound_dict() -> Dictionary:
	var sound_container_dict = {
		"master_volume" : master_volume,
		"master_music_volume" : master_music_volume,
		"master_sfx_volume" : master_sfx_volume,
		"music_menu_volume" : music_menu_volume,
		"music_game_volume" : music_game_volume,
		"music_boss_volume" : music_boss_volume,
		"sfx_environment_volume" : sfx_environment_volume,
		"sfx_player_volume" : sfx_player_volume,
	}
	return sound_container_dict


func create_accsesability_dict() -> Dictionary:
	var accsesability_container_dict = {
		
	}
	return accsesability_container_dict


func create_controls_dict() -> Dictionary:
	var controls_container_dict = {
		"move_left" : move_left,
		"move_right" : move_right,
		"crouch" : crouch,
		"jump" : jump,
		"interact" : interact
	}
	return controls_container_dict


func create_graphics_dict() -> Dictionary:
	var graphics_container_dict = {
		"window_mode_index" : window_mode_index,
		"window_mode_windowed" : window_mode_windowed,
		"resolution_custom_x" : resolution_custom_x,
		"resolution_custom_y" : resolution_custom_y,
	}
	return graphics_container_dict


func get_window_mode_index() -> int:
	if loaded_settings_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_WINDOW_MODE_INDEX
	return window_mode_index


func get_window_mode_windowed() -> bool:
	if loaded_settings_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_WINDOW_MODE_WINDOWED
	return window_mode_windowed


func get_resolution_custom_x() -> float:
	if loaded_settings_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_RESOLUTION_CUSTOM_X
	return resolution_custom_x


func get_resolution_custom_y() -> float:
	if loaded_settings_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_RESOLUTION_CUSTOM_Y
	return resolution_custom_y


func get_sound(bus : int):
	if loaded_settings_data == {}:
		match bus:
			0:
				return DEFAULT_SETTINGS.DEFAULT_MASTER_VOLUME
			1:
				return DEFAULT_SETTINGS.DEFAULT_MASTER_MUSIC_VOLUME
			2:
				return DEFAULT_SETTINGS.DEFAULT_MASTER_SFX_VOLUME
			3:
				return DEFAULT_SETTINGS.DEFAULT_MUSIC_MENU_VOLUME
			4:
				return DEFAULT_SETTINGS.DEFAULT_MUSIC_GAME_VOLUME
			5:
				return DEFAULT_SETTINGS.DEFAULT_MUSIC_BOSS_VOLUME
			6:
				return DEFAULT_SETTINGS.DEFAULT_SFX_ENVIROMENT_VOLUME
			7:
				return DEFAULT_SETTINGS.DEFAULT_SFX_PLAYER_VOLUME
	else:
		match bus:
			0:
				return master_volume
			1:
				return master_music_volume
			2:
				return master_sfx_volume
			3:
				return music_menu_volume
			4:
				return music_game_volume
			5:
				return music_boss_volume
			6:
				return sfx_environment_volume
			7:
				return sfx_player_volume


func get_controls(action_name, validate : bool):
	match action_name:
		"move_left":
			if not move_left == null:
				if validate:
					return true
				else:
					return move_left
			else:
				if validate:
					return false
		"move_right":
			if not move_right == null:
				if validate:
					return true
				else:
					return move_right
			else:
				if validate:
					return false
		"crouch":
			if not crouch == null:
				if validate:
					return true
				else:
					return crouch
			else:
				if validate:
					return false
		"jump":
			if not jump == null:
				if validate:
					return true
				else:
					return jump
			else:
				if validate:
					return false
		"interact":
			if not interact == null:
				if validate:
					return true
				else:
					return interact
			else:
				if validate:
					return false




func set_sound(bus : int, value : float):
	match bus:
		0:
			master_volume = value
		1:
			master_music_volume = value
		2:
			master_sfx_volume = value
		3:
			music_menu_volume = value
		4:
			music_game_volume = value
		5:
			music_boss_volume = value
		6:
			sfx_environment_volume = value
		7:
			sfx_player_volume = value


func set_controls(action_name : String, keycode):
	var inputString = str(keycode).replace('InputEventKey: ', '')
	var inputRawArray = inputString.split(",")
	for inputItem in inputRawArray:
		if inputItem.begins_with("keycode"):
			keycode = inputItem.replace('keycode=', '')
	match action_name:
		"move_left":
			move_left = keycode
		"move_right":
			move_right = keycode
		"crouch":
			crouch = keycode
		"jump":
			jump = keycode
		"interact":
			interact = keycode


func set_graphics(type : int, value):
	match type:
		1:
			window_mode_index = value
		2:
			window_mode_windowed = value
		3:
			resolution_custom_x = value
		4:
			resolution_custom_y = value


func on_sound_loaded(dict : Dictionary):
	master_volume = dict.master_volume
	master_music_volume = dict.master_music_volume
	master_sfx_volume = dict.master_sfx_volume
	music_menu_volume = dict.music_menu_volume
	music_game_volume = dict.music_game_volume
	music_boss_volume = dict.music_boss_volume
	sfx_environment_volume = dict.sfx_environment_volume
	sfx_player_volume = dict.sfx_player_volume


func on_controls_loaded(dict : Dictionary):
	move_left = dict.move_left
	move_right = dict.move_right
	crouch = dict.crouch
	jump = dict.jump
	interact = dict.interact


func on_graphics_loaded(dict : Dictionary):
	window_mode_index = dict.window_mode_index
	window_mode_windowed = dict.window_mode_windowed
	resolution_custom_x = dict.resolution_custom_x
	resolution_custom_y = dict.resolution_custom_y


func on_settings_data_loaded(data : Dictionary):
	Console.Print("Save", "Output", "loaded_save_data: %s" % data)
	loaded_settings_data = data
	on_sound_loaded(loaded_settings_data.sound)
	on_controls_loaded(loaded_settings_data.controls)
	on_graphics_loaded(loaded_settings_data.graphics)
