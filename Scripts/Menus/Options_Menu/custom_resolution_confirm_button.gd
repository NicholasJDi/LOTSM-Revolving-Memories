extends Control


func _on_button_button_down() -> void:
	SignalBus.Emit_Resolution_Custom_Confirm()


func _on_button_button_up():
	SignalBus.Emit_Resolution_Custom_Confirm_Alt()
