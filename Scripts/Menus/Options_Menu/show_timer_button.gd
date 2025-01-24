extends Control

@onready var button: Button = $HBoxContainer/Button


func _process(_delta) -> void:
	if Global.timer:
		button.text = "Hide"
	else:
		button.text = "Show"

func _on_button_pressed() -> void:
	if Global.timer:
		Global.timer = false
	else:
		Global.timer = true
