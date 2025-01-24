extends Node

var unfocused_pause = true
var timer = false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("console_show"):
		ConsoleWindow.visible = !ConsoleWindow.visible
	if event.is_action_pressed("timer_show"):
		timer = !timer
