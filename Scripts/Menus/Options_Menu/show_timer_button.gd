extends Control

@onready var button: Button = $HBoxContainer/Button


func _process(_delta) -> void:
	if SettingsDataContainer.Storage_Dict.accsesability.timer_visible:
		button.text = "Hide"
	else:
		button.text = "Show"

func _on_button_pressed() -> void:
	SettingsDataContainer.Storage_Dict.accsesability.timer_visible = !SettingsDataContainer.Storage_Dict.accsesability.timer_visible
