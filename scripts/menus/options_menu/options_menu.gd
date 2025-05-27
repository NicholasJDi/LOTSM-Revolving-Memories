extends Control
class_name OptionsMenu
##A Easy To Use Options Menu.
##
##A Simple And Easy To Use Options Menu That Uses Godots Built In ConfigFile System.[br]
##[br]
##Make Sure To Set [member Parent_Menu] Properly!

##Force All Other Instances Of The Options Menu To Use This Instances Settings.[br]
##(Excluding: [member Parent_Menu] And [member Globalize_Settings].)
@export var Globalize_Settings : bool
##The Parent Of The Options Menu. For Example: A Main Menu Or Pause Menu.[br][br]
##This Is Used To Show The Parent Menu When [method exit] Is Called
@export var Parent_Menu : Node
##A List Of Audio Busses,[br]
##[br]
##Keys Act As Bus Names,[br]
##Values Act As Default Values. (0.0 - 100.0)
@export var Audio_Busses : Dictionary[String, float] = {}
##A List Of Keybinds.[br]
##[br]
##Keys Act As Input Actions,[br]
##Values Act As Display Names.[br]
##[br]
##Prefix Keys With A / To Make The Keybind Unchangable,[br]
@export var Keybind_List : Dictionary[String, String] = {}

##The Tab Container.
@onready var tab_container: TabContainer = $MarginContainer/TabContainer
##The Gameplay Tab.
@onready var gameplay: VBoxContainer = $MarginContainer/TabContainer/Gameplay/ScrollContainer/VBoxContainer
##The Controls Tab.
@onready var controls: VBoxContainer = $MarginContainer/TabContainer/Controls/ScrollContainer/VBoxContainer
##The Audio Tab.
@onready var audio: VBoxContainer = $MarginContainer/TabContainer/Audio/ScrollContainer/VBoxContainer
##The Graphics Tab.
@onready var graphics: VBoxContainer = $MarginContainer/TabContainer/Graphics/ScrollContainer/VBoxContainer

##Current Conig File.
var config_file = ConfigFile.new()
##Config File Path.
const SETTINGS_FILE_PATH = "user://settings.cfg"

func _ready() -> void:
	if FileAccess.file_exists(SETTINGS_FILE_PATH):
		config_file.load(SETTINGS_FILE_PATH)
	else:
		for Bus in Audio_Busses:
			config_file.set_value("Audio", Bus, Audio_Busses.get(Bus))
		config_file.save(SETTINGS_FILE_PATH)
	for Key in Keybind_List:
		var node = load("res://scenes/menus/options_menu/keybind_rebind_button.tscn").instantiate()
		node.Parent = self
		node.Key = Key
		node.Display_Name = Keybind_List.get(Key)
		controls.add_child(node)
	for Bus in Audio_Busses:
		var node = load("res://scenes/menus/options_menu/audio_slider.tscn").instantiate()
		node.Parent = self
		node.Bus = Bus
		audio.add_child(node)

func _input(event: InputEvent) -> void:
	if event.is_action("pause") and self.visible:
		exit()

func _on_back_pressed() -> void:
	exit()

##Hides The Options Menu, Shows The [member Parent_Menu], And Saves Changes.
func exit():
	Parent_Menu.visible = true
	self.visible = false
	config_file.save(SETTINGS_FILE_PATH)
