@tool
extends Button

##Weather Or Not Hovering Over Or Pressing The Button Will Shift The Position.
@export var disable_interactions : bool
@export var hover_move : float
@export_group("Polygon")
@export var top_distance : float
@export var bottom_distance : float
@export_group("Offsets")
@export var right_offset : float
@export var left_offset : float

@onready var button_polygon: Polygon2D = $ButtonPolygon
@onready var mask_polygon: CollisionPolygon2D = $Area2D/MaskPolygon
@onready var area_2d: Area2D = $Area2D

@onready var target_position = position.x

func _process(_delta: float) -> void:
	var size_x
	if top_distance > bottom_distance:
		size_x = size.x - top_distance
	else:
		size_x = size.x - bottom_distance
	button_polygon.polygon[0] = Vector2(0 - left_offset,0)
	button_polygon.polygon[1] = Vector2(0 - left_offset,size.y)
	button_polygon.polygon[2] = Vector2(size_x + bottom_distance - right_offset,size.y)
	button_polygon.polygon[3] = Vector2(size_x + top_distance - right_offset,0)
	mask_polygon.polygon[0] = Vector2(size.x,0)
	mask_polygon.polygon[1] = Vector2(size.x,size.y)
	mask_polygon.polygon[2] = Vector2(size_x + bottom_distance - right_offset,size.y)
	mask_polygon.polygon[3] = Vector2(size_x + top_distance - right_offset,0)

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint() and not disable_interactions:
		position.x = move_toward(position.x, target_position, 500 * delta)

func _on_mouse_entered() -> void:
	target_position += hover_move

func _on_mouse_exited() -> void:
	target_position -= hover_move

func _on_area_2d_mouse_entered() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	ConsoleWindow.Print("A")

func _on_area_2d_mouse_exited() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	ConsoleWindow.Print("E")
