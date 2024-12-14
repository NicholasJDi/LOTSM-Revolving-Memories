extends Node2D

var test : Array = [
	{"text" : "sample"}
]

func _ready() -> void:
	for item in test:
		print(item.text)
