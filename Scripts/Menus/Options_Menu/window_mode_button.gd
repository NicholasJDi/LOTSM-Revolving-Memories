class_name WindowModeButton
extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const WINDOW_MODE_ARRAY = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
]


func _ready():
	add_window_mode_items()
	option_button.item_selected.connect(on_window_mode_selected)
	load_data()


func load_data():
	option_button.select(SettingsDataContainer.get_window_mode_index())
	on_window_mode_selected(SettingsDataContainer.get_window_mode_index())


func add_window_mode_items():
	for window_mode in WINDOW_MODE_ARRAY:
		option_button.add_item(window_mode)


func on_window_mode_selected(index):
	SettingsDataContainer.set_graphics(1, index)
	match index:
		0: # Full-Screen
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			SignalBus.Emit_Resolution(false)
			SettingsDataContainer.set_graphics(2, false)
			SignalBus.Emit_Resolution_Custom(false)
			Console.Print("Settings", "Output", "window_mode_select_full-screen")
		1: # Window Mode
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(Vector2i(1152, 648))
			SignalBus.Emit_Resolution(true)
			SettingsDataContainer.set_graphics(2, true)
			SignalBus.Emit_Resolution_Custom(false)
			Console.Print("Settings", "Output", "window_mode_select_window_mode")
		2: # borderless Window
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_size(Vector2i(1152, 648))
			SignalBus.Emit_Resolution(true)
			SettingsDataContainer.set_graphics(2, true)
			SignalBus.Emit_Resolution_Custom(false)
			Console.Print("Settings", "Output", "window_mode_select_borderless_window")
		3: # Borderless Full-Screen
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			SignalBus.Emit_Resolution(false)
			SettingsDataContainer.set_graphics(2, false)
			SignalBus.Emit_Resolution_Custom(false)
			Console.Print("Settings", "Output", "window_mode_select_borderless_full-screen")
