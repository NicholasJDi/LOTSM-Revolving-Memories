extends Node

var default_save_file_data = {
	"file":{
	"location":"",
	"date_created":"",
	"last_played":""
	}, # file
	"data":{
	"player":{
	"time" : 0.0,
	"zoom":{"x":3.0,"y":3.0},
	"location":{"x":0,"y":0},
	"checkpoint":{"x":0,"y":0},
	"level" : "0",
	"powers":0
	}, # player
	"world" : {
	"level_0" : {
	}, # level 0
	"level_1" : {
	} # level 1
	} # world
	} # data
	}

var save_file_data : Dictionary

var Storage_Dict = {
	"accsesability":{
	},
	"controls":{
	"crouch":null,
	"dash":null,
	"interact":null,
	"jump":null,
	"move_left":null,
	"move_right":null,
	"slide":null,
	"wall_grab":null
	},
	"sound":{
	"master_music_volume":0.5,
	"master_sfx_volume":0.5,
	"master_volume":0.5,
	"music_boss_volume":1,
	"music_game_volume":1,
	"music_menu_volume":0.5,
	"sfx_environment_volume":1,
	"sfx_player_volume":1
	}
	}

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	save_file_data = default_save_file_data

func On_Data_Loaded(Data : Dictionary) -> void:
	ConsoleWindow.Print("loaded_save_data: %s" % Data, "Save", "Output")
	Storage_Dict = Data
