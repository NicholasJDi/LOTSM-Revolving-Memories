extends Node

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

# Exit Options Menu
signal Exit_Options_Menu
signal Exit_Options_Menu_External
func Emit_Exit_Options_Menu():
	Exit_Options_Menu.emit()
func Emit_Exit_Options_Menu_External():
	Exit_Options_Menu_External.emit()

# Exit Play Menu
signal Exit_Play_Menu
func Emit_Exit_Play_Menu():
	Exit_Play_Menu.emit()
