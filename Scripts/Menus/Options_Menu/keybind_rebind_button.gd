class_name HotkeyRebindButton
extends Control

@onready var label : Label = $HBoxContainer/Label
@onready var label_2: Label = $HBoxContainer/Label2
@onready var button : Button = $HBoxContainer/Button
@onready var action_name : String = self.name

@export var action : String = ""


func _ready() -> void:
	label.text = str(action_name).capitalize()
	if not action == "":
		label_2.text = "Unable To Change"
		button.text = action
	else:
		if SettingsDataContainer.Storage_Dict.controls[action_name] == null:
			set_text_for_key()
		else:
			var input = str(SettingsDataContainer.Storage_Dict.controls[action_name])
			var inputString = input.replace('InputEventKey: ', '')
			var inputRawArray = inputString.split(",")
			for inputItem in inputRawArray:
				if inputItem.begins_with("keycode"):
					var keycode = inputItem.replace('keycode=', '')
					var event = InputEventKey.new()
					event.keycode = int(keycode)
					InputMap.action_erase_events(action_name)
					InputMap.action_add_event(action_name, event)
					button.text = OS.get_keycode_string(int(keycode))
					var action_events = InputMap.action_get_events(action_name)
					var action_event = action_events[0]
					ConsoleWindow.Print("Global", "Output", action_event)

func _process(_delta: float) -> void:
	if button.has_focus() and action == "":
		if not button.text == "Press Any Key..":
			button.text = "Press Any Key.."
		
	else:
		if button.text == "Press Any Key..":
			set_text_for_key()

func _unhandled_key_input(event: InputEvent) -> void:
	if button.has_focus() and action == "":
		SettingsDataContainer.Storage_Dict.controls[action_name] = event
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		set_text_for_key()
		button.release_focus()


func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	button.text = action_keycode
