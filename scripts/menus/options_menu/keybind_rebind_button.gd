extends Control

@export var Parent : Control

@export var Key : String
@export var Display_Name : String

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button

func _ready() -> void:
	if Parent.config_file.has_section_key("Keybinds", Key):
		var event = InputEventKey.new()
		event.keycode = Parent.config_file.get_value("Keybinds", Key)
		Bind(event)
	if Key.begins_with("/"):
		button.disabled = true
		Key = Key.replace("/","")
	label.text = Display_Name
	update_button_text()

func _process(_delta: float) -> void:
	if button.has_focus() and not button.disabled:
		button.text = "..."
	else:
		update_button_text()

func _unhandled_key_input(event: InputEvent) -> void:
	if button.has_focus() and not button.disabled:
		Bind(event)

func update_button_text():
	var Event = InputMap.action_get_events(Key)
	if not Event.is_empty():
		if Event is Array: 
				Event = Event.front()
		if not Event == null:
			button.text = Event.as_text().replace(" (Physical)","")

func Bind(event : InputEvent):
	InputMap.action_erase_events(Key)
	InputMap.action_add_event(Key, event)
	Parent.config_file.set_value("Keybinds", Key, event.keycode)
	button.release_focus()
