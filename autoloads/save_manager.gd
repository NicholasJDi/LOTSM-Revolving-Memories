extends Node

var data : Dictionary = {
	"player":{
		"location":{"x":0.0,"y":0.0},
		"checkpoint":{"x":0.0,"y":0.0},
		"zoom":{"x":3.5,"y":3.5},
		"powers":0
	}, #Player
	"game":{}
	}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	DirAccess.make_dir_absolute("user://saves")
	save_file(0)
	print(load_file(0))


func save_file(slot : int):
	var json_string = JSON.stringify(data)
	var file = FileAccess.open("user://saves/save_" + str(slot), FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

func load_file(slot : int):
	data = JSON.parse_string(FileAccess.get_file_as_string("user://saves/save_" + str(slot)))
