extends Node

const Data_Path : Dictionary = {
	"Settings" : "user://Settings/Options.txt",
	"Console" : "user://Settings/Console.dat",
}

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	DirAccess.make_dir_absolute("user://Settings")
	DirAccess.make_dir_absolute("user://Saves")
	Load_Data("Settings")
	Load_Data("Console")

func Save_File_Get(Name : String) -> String:
	Name = "user://Saves/" + Name.to_lower().replace(" ", "_") + ".save"
	if FileAccess.file_exists(Name):
		return "Error: File Already Exists"
	return Name

func Save_File_Save(Data : Dictionary, File : String, New : bool = false) -> void:
	if New:
		if FileAccess.file_exists(File):
			ConsoleWindow.Print("Failed To Create File, Error Context: File Already Exists", "Save", "Error")
			return
		SettingsDataContainer.save_file_data.file.location = File
		SettingsDataContainer.save_file_data.file.date_created = Time.get_datetime_string_from_system().replace("T", "-")
	elif not FileAccess.file_exists(File):
		ConsoleWindow.Print("Failed To Save File, Error Context: File Does Not Exist", "Save", "Error")
		return
	var temp_data = {
	"file":{
		"location":SettingsDataContainer.save_file_data.file.location,
		"date_created":SettingsDataContainer.save_file_data.file.date_created,
		"last_played":Time.get_datetime_string_from_system().replace("T", "-")},
	"data":Data
	}
	var save_data_file = FileAccess.open(File, FileAccess.WRITE)
	var json_data_string = JSON.stringify(temp_data)
	save_data_file.store_line(json_data_string)
	save_data_file.close()

func Save_File_Load(File : String) -> void:
	if not FileAccess.file_exists(File):
		ConsoleWindow.Print("Failed To Load File, Error Context: File Does Not Exist", "Save", "Error")
		return
	var save_data_file = FileAccess.open(File, FileAccess.READ)
	var Loaded_Data : Dictionary = {}
	while save_data_file.get_position() < save_data_file.get_length():
		var json_string = save_data_file.get_line()
		var json = JSON.new()
		var _passed_result = json.parse(json_string)
		Loaded_Data = json.get_data()
	save_data_file.close()
	SettingsDataContainer.save_file_data = Loaded_Data

func Save_Data(Data : Dictionary, Type : String) -> void:
	var File = Data_Path[Type]
	var save_data_file = FileAccess.open(File, FileAccess.WRITE)
	var json_data_string = JSON.stringify(Data)
	save_data_file.store_line(json_data_string)
	save_data_file.close()

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
	save_data_file.close()
