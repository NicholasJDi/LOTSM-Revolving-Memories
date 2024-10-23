extends Control

@onready var console_log: RichTextLabel = $MarginContainer/VBoxContainer/ConsoleLog
@onready var input_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/InputLabel
@onready var input_field: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/InputField

@onready var main_menu: Control = $"."

var username = "User"
var selected_command : int = -1
var last_commands : Array = [
	"/help"
]

var Type = {
	"Global" : {"color" : "#ffffff", "visible" : "true"},
	"Help" : {"color" : "#ff9700", "visible" : "null"},
	"Player" : {"color" : "#c50000", "visible" : "true"},
	"Scene" : {"color" : "#0c48ff", "visible" : "true"},
	"Menu" : {"color" : "#9300b8", "visible" : "true"},
	"UI" : {"color" : "#00a000", "visible" : "true"},
	"Item" : {"color" : "#ad6c00", "visible" : "true"},
	"Save" : {"color" : "#ffb000", "visible" : "true"},
	"Settings" : {"color" : "#8c8c8c", "visible" : "true"},
	"User" : {"color" : "#ffffff", "visible" : "null"}
}

var Level = {
	"Global" : {"color" : "#ffffff"},
	"Output" : {"color" : "#acacac"},
	"Warning" : {"color" : "#ff9700"},
	"Error" : {"color" : "#ff0000"}
}

func _ready() -> void:
	Console._Print.connect(Print)
	add_message(Console.type, Console.level, Console.text)
	Type = Console.Type
	last_commands = Console.Last_Commands
	username = Console.Username
	input_label.text = "[" + username + "]"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("console_show"):
		if ConsoleWindow.visible:
			ConsoleWindow.hide()
		else:
			ConsoleWindow.show()
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
		console_log.text += "[color=" + Type[type].color + "][" + username + "][/color] " +  text
		print("[" + level + "][" + username + "] " + text)
	elif not Type[type].visible == "false":
		if console_log.text != "":
			console_log.text += "\n"
		console_log.text += "[color=" + Type[type].color + "][" + type + "][/color] " +  "[color=" + Level[level].color + "]" + text + "[/color]"
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


func Print():
	add_message(Console.type, Console.level, Console.text)


func use_command(text):
	var success = "Not"
	if last_commands[0] != text:
		last_commands.insert(0, text)
	selected_command = -1
	if last_commands.size() == 11:
		last_commands.pop_back()
	Console.Last_Commands = last_commands
	if text == "/help" or text == "/h":
		Console.Print("Help", "Global", "Commands:\n/help Or /h Shows This Menu\n/name (name) Change The Name The Console Refers To You As\n/scene (scene) Force The Game To Change To Another Scene\n/hide (type) Hides A Specific Output Type.\n/show (type) Shows A Specific Output Type.\n/quit Forces The Game To Close")
		success = "Suc"
	elif text.begins_with("/name"):
		if text == "/name" or text == "/name " or text == "/name help" or  text == "/name h":
			Console.Print("Help", "Global", "/name Usage:\n/name (name) Change The Name The Console Refers To You As")
			success = "Suc"
		else:
			var tempusername = text.replace("/name ", "")
			if tempusername.count(tempusername, 0, 14):
				username = text.replace("/name ", "")
				Console.Username = text.replace("/name ", "")
				input_label.text = "[" + username + "]"
				Console.Print("Help", "Global", "Success! The Console Will Now Refer To You As %s" % username)
				success = "Suc"
			else:
				Console.Print("Help", "Error", "Name Too Long, Max: 14 Given: %s" % tempusername.length())
				success = "Err"
	elif text.begins_with("/scene"):
		if text == "/scene" or text == "/scene " or text == "/scene help" or  text == "/scene h":
			Console.Print("Help", "Global", "/scene Usage:\n/scene (scene) Force The Game To Change To Another Scene\nValues:\nmain menu, level 0.")
			success = "Suc"
		else:
			if text.replace("/scene ", "") == "main menu":
				Console.Print("Help", "Global", "Success! Loading Scene Main_Menu")
				get_tree().change_scene_to_file("res://Scenes/Menus/Main_Menu.tscn")
				success = "Suc"
			elif text.replace("/scene ", "") == "level 0":
				Console.Print("Help", "Global", "Success! Loading Scene Level_0")
				get_tree().change_scene_to_file("res://Scenes/Levels/Level_0.tscn")
				success = "Suc"
			else:
				success = "Syn"
	elif text.begins_with("/hide"):
		var temp_data = text.replace("/hide ", "")
		temp_data = temp_data.capitalize()
		if text == "/hide" or text == "/hide " or text == "/hide help" or  text == "/hide h":
			Console.Print("Help", "Global", "/hide Usage:\n/hide (type) Hides A Specific Output Type.\nValues:\nglobal, player, scene, menu, ui, item, save, settings")
			success = "Suc"
		elif temp_data == "Global" or temp_data == "Player" or temp_data == "Scene" or temp_data == "Menu" or temp_data == "Ui" or temp_data == "Item" or temp_data == "Save" or temp_data == "Settings":
			if Type[temp_data].visible == "true": 
				Type[temp_data].visible = "false"
				Console.Print("Help", "Global", "Success! Type Has Been Hidden")
				success = "Suc"
			else:
				Console.Print("Help", "Error", "Type Already Hidden")
				success = "Err"
		else:
			success = "Syn"
	elif text.begins_with("/show"):
		var temp_data = text.replace("/show ", "")
		temp_data = temp_data.capitalize()
		if text == "/show" or text == "/show " or text == "/show help" or  text == "/show h":
			Console.Print("Help", "Global", "/show Usage:\n/show (type) Shows A Specific Output Type.\nValues:\nglobal, player, scene, menu, ui, item, save, settings")
			success = "Suc"
		elif temp_data == "Global" or temp_data == "Player" or temp_data == "Scene" or temp_data == "Menu" or temp_data == "Ui" or temp_data == "Item" or temp_data == "Save" or temp_data == "Settings":
			if Type[temp_data].visible == "false": 
				Type[temp_data].visible = "true"
				Console.Print("Help", "Global", "Success! Type Has Been Shown")
				success = "Suc"
			else:
				Console.Print("Help", "Error", "Type Already Shown")
				success = "Err"
		else:
			success = "Syn"
	elif text.begins_with("/quit"):
		if text == "/quit" or text == "/quit ":
			success = "Qui"
		elif text == "/quit help" or text == "/quit h":
			Console.Print("Help", "Global", "/quit Usage:\n/quit Forces The Game To Close.")
			success = "Suc"
		else:
			success = "Syn"
	if success == "Not":
		Console.Print("Help", "Error", "Command Not Found")
	elif success == "Syn":
		Console.Print("Help", "Error", "Invalid Syntax")
	SaveManager.Save_Data(Console.create_storage_dictionary(), "Console")
	if success == "Qui":
		get_tree().quit()
