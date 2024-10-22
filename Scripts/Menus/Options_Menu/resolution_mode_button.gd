extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

var Resolution_Custom_X_Var = 0
var Resolution_Custom_Y_Var = 0

func _ready():
	Resolution_Custom_X_Var = SettingsDataContainer.get_resolution_custom_x()
	Resolution_Custom_Y_Var = SettingsDataContainer.get_resolution_custom_y()
	add_resolution_items()
	option_button.item_selected.connect(on_resolution_selected)
	SignalBus.Resolution.connect(Resolution)
	SignalBus.Resolution_Custom_X.connect(Resolution_Custom_X)
	SignalBus.Resolution_Custom_Y.connect(Resolution_Custom_Y)
	SignalBus.Resolution_Custom_Confirm_Alt.connect(Resolution_Custom_Confirm_Alt)


func add_resolution_items():
	option_button.add_item("1152 x 648", 0)
	option_button.add_item("1280 x 720", 1)
	option_button.add_item("1920 x 1080", 2)
	option_button.add_item("Custom - " + str(Resolution_Custom_X_Var) + " x " + str(Resolution_Custom_Y_Var), 3)


func Resolution(value):
	if value:
		option_button.select(0)


func Resolution_Custom_X(value):
	Resolution_Custom_X_Var = value


func Resolution_Custom_Y(value):
	Resolution_Custom_Y_Var = value


func Resolution_Custom_Confirm_Alt():
	option_button.remove_item(3)
	option_button.add_item("Custom - " + str(Resolution_Custom_X_Var) + " x " + str(Resolution_Custom_Y_Var), 3)
	option_button.select(3)
	on_resolution_selected(option_button.selected)


func on_resolution_selected(index : int):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1152, 648))
			DisplayServer.window_set_position(Vector2i(0, 0))
			SignalBus.Emit_Resolution_Custom(false)
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			DisplayServer.window_set_position(Vector2i(0, 0))
			SignalBus.Emit_Resolution_Custom(false)
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			DisplayServer.window_set_position(Vector2i(0, 0))
			SignalBus.Emit_Resolution_Custom(false)
		3:
			DisplayServer.window_set_size(Vector2i(Resolution_Custom_X_Var, Resolution_Custom_Y_Var))
			DisplayServer.window_set_position(Vector2i(0, 0))
			SignalBus.Emit_Resolution_Custom(true)
