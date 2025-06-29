extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func transition_to_scene():
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("console_show"):
		ConsoleWindow.show()
