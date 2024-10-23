extends Node

var Storage_Dict = {
	"accsesability":{},
	
	"controls":{
	"crouch":null,
	"interact":null,
	"jump":null,
	"move_left":null,
	"move_right":null},
	
	"graphics":{
	"resolution_custom_x":1152,
	"resolution_custom_y":648,
	"window_mode_index":3,
	"window_mode_windowed":false},
	
	"sound":{
	"master_music_volume":0.5,
	"master_sfx_volume":0.5,
	"master_volume":0.5,
	"music_boss_volume":1,
	"music_game_volume":1,
	"music_menu_volume":0.5,
	"sfx_environment_volume":1,
	"sfx_player_volume":1}}

func Get_Save_Data() -> Dictionary:
	return Storage_Dict


func Get_Data(Category : String, Type : String):
	return Storage_Dict[Category][Type]


func Set_Data(Category : String, Type : String, Value) -> void:
	Storage_Dict[Category][Type] = Value


func On_Data_Loaded(Data : Dictionary) -> void:
	Console.Print("Save", "Output", "loaded_save_data: %s" % Data)
	Storage_Dict = Data
