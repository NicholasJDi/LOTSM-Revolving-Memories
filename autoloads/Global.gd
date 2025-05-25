extends Node

var unfocused_pause = true
var Player : PlayerCharacter

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("console_show"):
		ConsoleWindow.visible = !ConsoleWindow.visible


func Change_Scene(Scene_Path:String):
	await Player.ui.scene_transition.exit
	get_tree().change_scene_to_file(Scene_Path)
