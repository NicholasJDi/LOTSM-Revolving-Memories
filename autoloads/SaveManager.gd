extends Node

const SETTINGS_SAVE_PATH = "user://Options.txt"
const CONSOLE_SAVE_PATH = "user://Console.txt"
 
var settings_data_dict = {}


func _ready():
	load_settings_data()
	load_console_data()


func save_settings_data(data : Dictionary):
	var save_settings_data_file = FileAccess.open(SETTINGS_SAVE_PATH, FileAccess.WRITE)
	var json_data_string = JSON.stringify(data)
	save_settings_data_file.store_line(json_data_string)

func load_settings_data():
	if not FileAccess.file_exists(SETTINGS_SAVE_PATH):
		return
	var save_settings_data_file = FileAccess.open(SETTINGS_SAVE_PATH, FileAccess.READ)
	var Loaded_Settings_Data : Dictionary = {}
	while save_settings_data_file.get_position() < save_settings_data_file.get_length():
		var json_string = save_settings_data_file.get_line()
		var json = JSON.new()
		var _passed_result = json.parse(json_string)
		Loaded_Settings_Data = json.get_data()
	SettingsDataContainer.on_settings_data_loaded(Loaded_Settings_Data)


func save_console_data(data : Dictionary):
	var save_console_data_file = FileAccess.open(CONSOLE_SAVE_PATH, FileAccess.WRITE)
	var json_data_string = JSON.stringify(data)
	save_console_data_file.store_line(json_data_string)

func load_console_data():
	if not FileAccess.file_exists(CONSOLE_SAVE_PATH):
		return
	var save_console_data_file = FileAccess.open(CONSOLE_SAVE_PATH, FileAccess.READ)
	var Loaded_Console_Data : Dictionary = {}
	while save_console_data_file.get_position() < save_console_data_file.get_length():
		var json_string = save_console_data_file.get_line()
		var json = JSON.new()
		var _passed_result = json.parse(json_string)
		Loaded_Console_Data = json.get_data()
	Console.on_console_data_loaded(Loaded_Console_Data)
