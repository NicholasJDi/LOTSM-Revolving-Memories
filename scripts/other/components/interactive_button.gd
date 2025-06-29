@tool
extends Button

##Weather Or Not Hovering Over Or Pressing The Button Will Shift The Position.
@export var disable_interactions : bool
@export var hover_move : float
@export var top_distance : float
@export var bottom_distance : float
@export_group("Offsets")
@export var right_offset : float
@export var left_offset : float
@export var shadow_offset : Vector2
@export_group("Colors")
@export var idle_color : Color = "d93b9f"
@export var hovered_color : Color = "ed40ae"
@export var shadow_color : Color = "00000050"

@onready var button_polygon: Polygon2D = $ButtonPolygon
@onready var shadow_polygon: Polygon2D = $ButtonPolygon/ShadowPolygon

@onready var target_position = position.x


func _ready() -> void:
	button_polygon.color = idle_color

func _process(_delta: float) -> void:
	var size_x
	if top_distance > bottom_distance:
		size_x = size.x - top_distance
	else:
		size_x = size.x - bottom_distance
	button_polygon.polygon[0] = Vector2(0 + left_offset,0)
	button_polygon.polygon[1] = Vector2(0 + left_offset,size.y)
	button_polygon.polygon[2] = Vector2(size_x + bottom_distance - right_offset,size.y)
	button_polygon.polygon[3] = Vector2(size_x + top_distance - right_offset,0)
	shadow_polygon.polygon = button_polygon.polygon
	shadow_polygon.position = shadow_offset
	shadow_polygon.color = shadow_color
	if Engine.is_editor_hint():
		button_polygon.color = idle_color

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if Geometry2D.is_point_in_polygon(get_local_mouse_position(),button_polygon.polygon):
			mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			mouse_filter = Control.MOUSE_FILTER_IGNORE
		if not disable_interactions:
			position.x = move_toward(position.x, target_position, 500 * delta)

func _on_mouse_entered() -> void:
	z_index = 99
	button_polygon.color = hovered_color
	target_position += hover_move

func _on_mouse_exited() -> void:
	z_index = 0
	button_polygon.color = idle_color
	target_position -= hover_move
