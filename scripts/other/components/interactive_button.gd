extends Button
class_name InteractiveButton

##Weather Or Not Hovering Over Or Pressing The Button Will Shift The Position.
@export var disable_interactions : bool
@export_group("Hover")
@export var hover_move : Vector2
@export_group("Press")
@export var press_move_1 : Vector2
##How Much Time To Pause After Moveing By [member press_move_1] Before Moving By [member press_move_2].
@export var press_1_to_2_fade_time : float
@export var press_move_2 : Vector2

@onready var target_position = position

func _physics_process(delta: float) -> void:
	if not disable_interactions:
		self.position.x = move_toward(position.x, target_position.x, 500 * delta)
		self.position.y = move_toward(position.y, target_position.y, 500 * delta)


func _on_mouse_entered() -> void:
	target_position.x += hover_move.x
	target_position.y += hover_move.y
	ConsoleWindow.Print("e")

func _on_mouse_exited() -> void:
	target_position.x -= hover_move.x
	target_position.y -= hover_move.y
