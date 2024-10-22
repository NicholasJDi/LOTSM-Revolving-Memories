extends Node

# Exit Options Menu
signal Exit_Options_Menu
func Emit_Exit_Options_Menu():
	Exit_Options_Menu.emit()

# Game Frozen
signal Game_Frozen
func Emit_Game_Frozen(value):
	Game_Frozen.emit(value)

# Resolution
signal Resolution
func Emit_Resolution(value):
	Resolution.emit(value)

# Custom Resolution
signal Resolution_Custom
signal Resolution_Custom_Confirm
signal Resolution_Custom_Confirm_Alt
signal Resolution_Custom_X
signal Resolution_Custom_Y
func Emit_Resolution_Custom(value):
	Resolution_Custom.emit(value) 
func Emit_Resolution_Custom_Confirm():
	Resolution_Custom_Confirm.emit()
func Emit_Resolution_Custom_Confirm_Alt():
	Resolution_Custom_Confirm_Alt.emit()
func Emit_Resolution_Custom_X(value):
	Resolution_Custom_X.emit(value)
func Emit_Resolution_Custom_Y(value):
	Resolution_Custom_Y.emit(value)
