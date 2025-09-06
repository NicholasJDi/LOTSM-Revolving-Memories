extends Control
##A Easy To Use Options Menu.
##
##A Simple And Easy To Use Options Menu That Uses Godots Built In ConfigFile System.[br]
##[br]
##Make Sure To Set [member Parent_Menu] Properly!

##The Parent Of The Options Menu. For Example: A Main Menu Or Pause Menu.[br][br]
##This Is Used To Show The Parent Menu When [method exit] Is Called
@export var Parent_Menu : Node
##A List Of Audio Busses,[br]
##[br]
##Keys Act As Bus Names,[br]
##Values Act As Default Values. (0.0 - 100.0)
@export var Audio_Busses : Dictionary[String, float] = {
	"Master":50.0,
	"Master - Music":50.0,
	"Master - SFX":50.0,
	"Music - Menu":100.0,
	"Music - Game":100.0,
	"SFX - Environment":100.0,
	"SFX - Player":100.0,
	"SFX - Dialogue":100.0}
##A List Of Keybinds.[br]
##[br]
##Keys Act As Input Actions,[br]
##Values Act As Display Names.[br]
##[br]
##Prefix Keys With A / To Make The Keybind Unchangable,[br]
@export var Keybind_List : Dictionary[String, String] = {
	"move_left": "Move Left",
	"move_right": "Move Right",
	"crouch":"Crouch",
	"jump": "Jump",
	"dash":"Dash",
	"slide":"Slide",
	"wall_grab":"Wall Grab",
	"interact": "Interact",
	"swap_powers":"Swap Powers",
	"/pause": "Pause"
	}
	
@onready var scroll_container: ScrollContainer = $HBoxContainer/ScrollContainer
@onready var tab_container: TabContainer = $HBoxContainer/ScrollContainer/TabContainer
@onready var gameplay: VBoxContainer = $HBoxContainer/ScrollContainer/TabContainer/Gameplay
@onready var graphics: VBoxContainer = $HBoxContainer/ScrollContainer/TabContainer/Graphics
@onready var controls: VBoxContainer = $HBoxContainer/ScrollContainer/TabContainer/Controls
@onready var audio: VBoxContainer = $HBoxContainer/ScrollContainer/TabContainer/Audio
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var button_gameplay: Button = $Gameplay
@onready var button_graphics: Button = $Graphics
@onready var button_controls: Button = $Controls
@onready var button_audio: Button = $Audio
@onready var button_back: Button = $Back

@onready var background: ColorRect = $ColorRect

##Config File Path.
const SETTINGS_FILE_PATH = "user://settings.cfg"
##Current Conig File.
var config_file = ConfigFile.new()
##Whether To Prevent Toggled Recursion Or Not.
var prevent_recursion : bool


signal exited


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

func _on_toggled(_toggled_on: bool, tab: int) -> void:
	if prevent_recursion == false:
		prevent_recursion = true
		tab_container.current_tab = tab
		scroll_container.scroll_vertical = 0
		button_gameplay.button_pressed = false
		button_graphics.button_pressed = false
		button_controls.button_pressed = false
		button_audio.button_pressed = false
		match tab:
			0: # Gameplay
				button_gameplay.button_pressed = true
			1: # Graphics
				button_graphics.button_pressed = true
			2: # Controls
				button_controls.button_pressed = true
			3: # Audio
				button_audio.button_pressed = true
		prevent_recursion = false

func _on_back_pressed() -> void:
	exit()


func exit():
	config_file.save(SETTINGS_FILE_PATH)
	match tab_container.current_tab:
			0: # Gameplay
				animation_player.play("Settings_Menu/Exit - Gameplay")
			1: # Graphics
				animation_player.play("Settings_Menu/Exit - Graphics")
			2: # Controls
				animation_player.play("Settings_Menu/Exit - Controls")
			3: # Audio
				animation_player.play("Settings_Menu/Exit - Audio")
	await  animation_player.animation_finished
	Parent_Menu.show()
	hide()
	exited.emit()

func enter():
	prevent_recursion = true
	button_gameplay.button_pressed = true
	button_graphics.button_pressed = false
	button_controls.button_pressed = false
	button_audio.button_pressed = false
	prevent_recursion = false
	tab_container.current_tab = 0
	animation_player.play("Settings_Menu/Enter")
	await get_tree().process_frame
	show()
	Parent_Menu.hide()
