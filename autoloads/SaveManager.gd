extends Node

const Data_Path : Dictionary = {
	"Settings" : "user://Settings/Options.txt",
	"Console" : "user://Settings/Console.txt",
}

var settings_data_dict = {}

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	DirAccess.make_dir_absolute("user://Settings")
	DirAccess.make_dir_absolute("user://Saves")
	Load_Data("Settings")
	Load_Data("Console")

func Save_File_Save(Data : Dictionary, Name : String) -> void:
	Name = Name.to_lower()
	Name = Name.replace(" ", "_")
	var File = "user://Saves/" + Name
	var num : int = 0
	while  FileAccess.file_exists(File):
		var temp = File
		if num == 0:
			temp = temp + "0"
		temp = temp.left(temp.length() - str(num).length())
		num = num + 1
		File = temp + str(num)
	File = File + ".save"
	var save_data_file = FileAccess.open(File, FileAccess.WRITE)
	var json_data_string = JSON.stringify(Data)
	save_data_file.store_line(json_data_string)

func Save_Data(Data : Dictionary, Type : String) -> void:
	var File = Data_Path[Type]
	var save_data_file = FileAccess.open(File, FileAccess.WRITE)
	var json_data_string = JSON.stringify(Data)
	save_data_file.store_line(json_data_string)

func Load_Data(Type : String) -> void:
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
		ConsoleWindow.on_console_data_loaded(Loaded_Data)
