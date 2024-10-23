extends Node

const Data_Path : Dictionary = {
	"Settings" : "user://Options.txt",
	"Console" : "user://Console.txt"
}
 
var settings_data_dict = {}


func _ready():
	Load_Data("Settings")
	Load_Data("Console")


func Save_Data(Data : Dictionary, Type : String):
	var File = Data_Path[Type]
	var save_data_file = FileAccess.open(File, FileAccess.WRITE)
	var json_data_string = JSON.stringify(Data)
	save_data_file.store_line(json_data_string)

func Load_Data(Type : String):
	var File = Data_Path[Type]
	if not FileAccess.file_exists(File):
		return
	var save_data_file = FileAccess.open(File, FileAccess.READ)
	var Loaded_Data : Dictionary = {}
	while save_data_file.get_position() < save_data_file.get_length():
		var json_string = save_data_file.get_line()
		var json = JSON.new()
		var _passed_result = json.parse(json_string)
		Loaded_Data = json.get_data()
	if Type == "Settings":
		SettingsDataContainer.On_Data_Loaded(Loaded_Data)
	elif Type == "Console":
		Console.on_console_data_loaded(Loaded_Data)
