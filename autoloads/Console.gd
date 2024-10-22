extends Node

signal _Print

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
var Username = "User"
var Last_Commands : Array = [
	"/help"
]

var type = "Help"
var level = "Global"
var text = "Type /help For Commands"

func Print(Type : String, Level : String, Text):
	type = Type
	level = Level
	text = str(Text)
	_Print.emit()

func  create_storage_dictionary() -> Dictionary:
	var controls_container_dict : Dictionary = {
		"Type" : Type,
		"Username" : Username,
		"Last_Commands" : Last_Commands
	}
	return controls_container_dict

func on_console_data_loaded(data : Dictionary):
	Type = data.Type
	Username = data.Username
	Last_Commands = data.Last_Commands
