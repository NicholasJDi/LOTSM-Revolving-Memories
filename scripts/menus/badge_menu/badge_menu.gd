extends Control

@export var parent_menu : Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var back: Button = $Back
@onready var menu_container: ColorRect = $MenuContainer

signal exited


func ready():
	back.disable_interactions = true
	back.position.x = -737.0

func _input(event: InputEvent) -> void:
	if event.is_action("pause") and self.visible:
		exit() 

func _on_back_pressed() -> void:
	exit()

func exit():
	animation_player.play("Exit")
	await animation_player.animation_finished
	parent_menu.show()
	hide()
	exited.emit()

func enter():
	animation_player.play("Enter")
	await get_tree().process_frame
	show()
	parent_menu.hide()
