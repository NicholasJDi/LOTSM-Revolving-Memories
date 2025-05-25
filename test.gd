extends Control

func _on_button_pressed() -> void:
	if Dialogic.current_timeline != null:
		return
	var style = Dialogic.start("test")
	print(style.scene_file_path)
	
	
