extends Node

## The Currently Selected Save Slot.
@export var save_slot : int
@export var is_scene_transitioning : bool

## The Currently Loaded Game Data.
@export var data : Dictionary = {
	"player":{
		"location":{"x":0.0,"y":0.0},
		"checkpoint":{"x":0.0,"y":0.0},
		"zoom":{"x":2.0,"y":2.0},
		"power_set":0
	}, #Player
	"game":{}
	}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	DirAccess.make_dir_absolute("user://saves")
	save_game()
	load_game()
	print(data)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("console_show"):
		ConsoleWindow.show()

## Transition To A Scene With A Fade Out/In Effect And With Proper Saving.[br][br]
## [param scene_file]: Path To Scene File (packed scenes not supported)[br]
## [param out_time]: How Long The Fade Out Lasts (in seconds)[br]
## [param wait_time]: How Long To Wait Before The Fade In On Scene Load (in seconds)[br]
## [param in_time]: How Long The Fade In Lasts (in seconds)[br]
func transition_to_scene(scene_file : String, out_time : float = .5, wait_time : float = .5, in_time : float = .5):
	is_scene_transitioning = true
	print(out_time,",", wait_time,",", in_time)
	await GlobalUi.fade_out_scene(out_time)
	get_tree().change_scene_to_file(scene_file)
	await get_tree().create_timer(wait_time).timeout
	await GlobalUi.fade_in_scene(in_time)
	is_scene_transitioning = false


## Saves The Game.[member data], If A Slot Is Specified It Will Override [member save_slot]
func save_game(slot : int = -1):
	if slot != -1:
		save_slot = slot
	var file = FileAccess.open("user://saves/save_" + str(save_slot), FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

## Loads File Data To Game.[member data], If A Slot Is Specified It Will Override [member save_slot]
func load_game(slot : int = -1):
	if slot != -1:
		save_slot = slot
	data = JSON.parse_string(FileAccess.get_file_as_string("user://saves/save_" + str(save_slot)))
