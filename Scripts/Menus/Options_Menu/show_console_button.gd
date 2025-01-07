extends Control

@onready var button: Button = $HBoxContainer/Button
@onready var timer: Timer = $Timer


func _process(_delta) -> void:
	if ConsoleWindow.visible:
		button.text = "Hide"
	else:
		button.text = "Show"

func _on_button_pressed() -> void:
	if ConsoleWindow.visible:
		ConsoleWindow.hide()
	else:
		ConsoleWindow.show()
		timer.start(0.1)
		await timer.timeout
		get_window().grab_focus()
