extends Node2D

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Global.Paused:
		Console.print("Global", "Output", get_tree().paused)
