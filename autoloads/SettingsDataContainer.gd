extends Node

var Storage_Dict = {
	"accsesability":{
	},
	"controls":{
	"crouch":null,
	"interact":null,
	"jump":null,
	"move_left":null,
	"move_right":null
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

func On_Data_Loaded(Data : Dictionary) -> void:
	ConsoleWindow.Print("Save", "Output", "loaded_save_data: %s" % Data)
	Storage_Dict = Data
