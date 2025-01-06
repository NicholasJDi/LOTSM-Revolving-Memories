extends Window

@export var console_log: RichTextLabel = null
@export var input_label: Label = null
@export var input_field: LineEdit = null


var username = "User"
var selected_command : int = -1
var last_commands : Array = [
	"/help"
]

var Types = {
	"Global" : {"color" : "#ffffff", "visible" : "true"},
	"Debug" : {"color" : "#b87400", "visible" : "true"},
	"Help" : {"color" : "#ff9700", "visible" : "null"},
	"Player" : {"color" : "#c50000", "visible" : "true"},
	"Scene" : {"color" : "#0c48ff", "visible" : "true"},
	"Menu" : {"color" : "#9300b8", "visible" : "true"},
	"Ui" : {"color" : "#00a000", "visible" : "true"},
	"Item" : {"color" : "#ad6c00", "visible" : "true"},
	"Save" : {"color" : "#ffb000", "visible" : "true"},
	"Settings" : {"color" : "#5c5c5c", "visible" : "true"},
	"User" : {"color" : "#ffffff", "visible" : "null"}
}

var Levels = {
	"Global" : {"color" : "#ffffff"},
	"Output" : {"color" : "#acacac"},
	"Warning" : {"color" : "#ff9700"},
	"Error" : {"color" : "#ff0000"}
}

func _ready() -> void:
	input_label.text = "[" + username + "]"

func _input(event: InputEvent) -> void:
	if input_field.has_focus() and event.is_action_pressed("console_lose_focus"):
		input_field.release_focus()
	if input_field.has_focus() and event.is_action_pressed("console_last_command"):
		if selected_command != (last_commands.size() - 1):
			selected_command = selected_command + 1
		input_field.text =  last_commands[selected_command]
	if input_field.has_focus() and event.is_action_pressed("console_clear_text_field"):
		input_field.text = ""
		selected_command = -1

func add_message(type, level, text):
	if type == "User":
		if console_log.text != "":
			console_log.text += "\n"
		console_log.text += "[color=" + Types[type].color + "][" + username + "][/color] " +  text
		print("[" + level + "][" + username + "] " + text)
	elif not Types[type].visible == "false":
		if console_log.text != "":
			console_log.text += "\n"
		console_log.text += "[color=" + Types[type].color + "][" + type + "][/color] " + "[color=" + Levels[level].color + "]" + text + "[/color]"
		print("[" + level + "][" + type + "] " + text)


func _on_input_field_text_submitted(text: String) -> void:
	input_field.release_focus()
	if text != "": 
		add_message("User", "Global", text)
		if text.begins_with("/"):
			use_command(text)
		input_field.text = ""


func _on_console_window_focus_exited() -> void:
	input_field.release_focus()


func Print(Text, Type : String = "Debug", Level : String = "Output"):
	add_message(Type, Level, str(Text))


func use_command(text):
	var success = "Not"
	if last_commands[0] != text:
		last_commands.insert(0, text)
	selected_command = -1
	if last_commands.size() == 11:
		last_commands.pop_back()
	if text == "/help" or text == "/h":
		ConsoleWindow.Print("Commands:\n/help Or /h Shows This Menu.\n/name (name) Change The Name The Console Refers To You As.\n/list (list) Shows Lists Of Important Data.\n/scene (scene) Force The Game To Change To Another Scene.\n/reload Reloads The Current Scene.\n/hide (type) Hides A Specific Output Type.\n/show (type) Shows A Specific Output Type.\n/quit Forces The Game To Close.", "Help", "Global")
		success = "Suc"
	elif text.begins_with("/name"):
		if text == "/name" or text == "/name " or text == "/name help" or  text == "/name h":
			ConsoleWindow.Print("/name Usage:\n/name (name) Change The Name The Console Refers To You As", "Help", "Global")
			success = "Suc"
		else:
			var tempusername = text.replace("/name ", "")
			if tempusername.count(tempusername, 0, 14):
				username = text.replace("/name ", "")
				input_label.text = "[" + username + "]"
				ConsoleWindow.Print("Success! The Console Will Now Refer To You As %s" % username, "Help", "Global")
				success = "Suc"
			else:
				ConsoleWindow.Print("Name Too Long, Max: 14 Given: %s" % tempusername.length(), "Help", "Error")
				success = "Err"
	elif text.begins_with("/list"):
		if text == "/list" or text == "/list " or text == "/list help" or  text == "/list h":
			ConsoleWindow.Print("/list Usage:\n/list (list) Shows Lists Of Important Data\nValues:\noutput visibility.", "Help", "Global")
			success = "Suc"
		elif text == "/list output visibility":
			ConsoleWindow.Print("Current Output Visibility:\nGlobal: " + ConsoleWindow.Types.Global.visible.capitalize() + "\nDebug: " + ConsoleWindow.Types.Debug.visible.capitalize() + "\nPlayer: " + ConsoleWindow.Types.Player.visible.capitalize() + "\nScene: " + ConsoleWindow.Types.Scene.visible.capitalize() + "\nMenu: " + ConsoleWindow.Types.Menu.visible.capitalize() + "\nUi: " + ConsoleWindow.Types.Ui.visible.capitalize() + "\nItem: " + ConsoleWindow.Types.Item.visible.capitalize() + "\nSave: " + ConsoleWindow.Types.Save.visible.capitalize() + "\nSettings: " + ConsoleWindow.Types.Settings.visible.capitalize(), "Help", "Global")
			success = "Suc"
		else:
			success = "Syn"
	elif text.begins_with("/clear"):
		if text == "/clear " or text == "/clear help" or  text == "/clear h":
			ConsoleWindow.Print("/clear Usage:\n/clear Clears All Previus Consoe Log Data.", "Help", "Global")
			success = "Suc"
		elif text == "/clear":
			console_log.text = ""
			ConsoleWindow.Print("Success! Previous Console Log Data Has Been Cleared", "Help", "Global")
			success = "Suc"
		else:
			success = "Syn"
	elif text.begins_with("/scene"):
		if text == "/scene" or text == "/scene " or text == "/scene help" or  text == "/scene h":
			ConsoleWindow.Print("/scene Usage:\n/scene (scene) Force The Game To Change To Another Scene\nValues:\nmain menu, level 1.", "Help", "Global")
			success = "Suc"
		elif text.replace("/scene ", "") == "main menu":
			ConsoleWindow.Print("Success! Loading Scene Main_Menu", "Help", "Global")
			get_tree().change_scene_to_file("res://Scenes/Menus/Main_Menu.tscn")
			get_tree().paused = false
			success = "Suc"
		elif text.replace("/scene ", "") == "level 0":
			ConsoleWindow.Print("Success! Loading Scene Level_1", "Help", "Global")
			get_tree().change_scene_to_file("res://Scenes/Levels/Level_1.tscn")
			get_tree().paused = false
			success = "Suc"
		else:
			success = "Syn"
	elif text.begins_with("/reload"):
		if text == "/reload " or text == "/reload help" or  text == "/reload h":
			ConsoleWindow.Print("/reload Usage:\n/reload Reloads The Current Scene", "Help", "Global")
			success = "Suc"
		elif text == "/reload":
			if not SettingsDataContainer.save_file_data.is_empty():
				SaveManager.Save_File_Load(SettingsDataContainer.save_file_data.file.location)
			get_tree().reload_current_scene()
			ConsoleWindow.Print("Success! Reloading Current Scene", "Help", "Global")
			success = "Suc"
		else:
			success = "Syn"
	elif text.begins_with("/hide"):
		var temp_data = text.replace("/hide ", "")
		temp_data = temp_data.capitalize()
		if text == "/hide" or text == "/hide " or text == "/hide help" or  text == "/hide h":
			ConsoleWindow.Print("/hide Usage:\n/hide (type) Hides A Specific Output Type.\nValues:\nglobal, player, scene, menu, ui, item, save, settings.", "Help", "Global")
			success = "Suc"
		elif temp_data == "Global" or temp_data == "Player" or temp_data == "Scene" or temp_data == "Menu" or temp_data == "Ui" or temp_data == "Item" or temp_data == "Save" or temp_data == "Settings":
			if Types[temp_data].visible == "true": 
				Types[temp_data].visible = "false"
				ConsoleWindow.Print("Success! Type Has Been Hidden", "Help", "Global")
				success = "Suc"
			else:
				ConsoleWindow.Print("Type Already Hidden", "Help", "Error")
				success = "Err"
		else:
			success = "Syn"
	elif text.begins_with("/show"):
		var temp_data = text.replace("/show ", "")
		temp_data = temp_data.capitalize()
		if text == "/show" or text == "/show " or text == "/show help" or  text == "/show h":
			ConsoleWindow.Print("/show Usage:\n/show (type) Shows A Specific Output Type.\nValues:\nglobal, player, scene, menu, ui, item, save, settings.", "Help", "Global")
			success = "Suc"
		elif temp_data == "Global" or temp_data == "Player" or temp_data == "Scene" or temp_data == "Menu" or temp_data == "Ui" or temp_data == "Item" or temp_data == "Save" or temp_data == "Settings":
			if Types[temp_data].visible == "false":
				Types[temp_data].visible = "true"
				ConsoleWindow.Print("Success! Type Has Been Shown", "Help", "Global")
				success = "Suc"
			else:
				ConsoleWindow.Print("Type Already Shown", "Help", "Error")
				success = "Err"
		else:
			success = "Syn"
	elif text.begins_with("/quit"):
		if text == "/quit" or text == "/quit ":
			success = "Qui"
		elif text == "/quit help" or text == "/quit h":
			ConsoleWindow.Print("/quit Usage:\n/quit Forces The Game To Close.", "Help", "Global")
			success = "Suc"
		else:
			success = "Syn"
	if success == "Not":
		ConsoleWindow.Print("Command Not Found", "Help", "Error")
	elif success == "Syn":
		ConsoleWindow.Print("Invalid Syntax", "Help", "Error")
	SaveManager.Save_Data(ConsoleWindow.create_storage_dictionary(), "Console")
	if success == "Qui":
		get_tree().quit()

func  create_storage_dictionary() -> Dictionary:
	var dict : Dictionary = {
		"Type" : Types,
		"Username" : username,
		"Last_Commands" : last_commands
	}
	return dict

func on_console_data_loaded(data : Dictionary):
	Types = data.Type
	username = data.Username
	last_commands = data.Last_Commands

func _on_close_requested() -> void:
	self.hide()
