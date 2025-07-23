@tool
extends Button

##Weather Or Not Hovering Over Or Pressing The Button Will Shift The Position.
@export var disable_interactions : bool
@export var flip_polygon : bool
@export var hover_move : float
@export var toggle_move : float
@export var focus_move : float
@export var target_position : float
@export var top_distance : float
@export var bottom_distance : float
@export_group("Outline")
@export var outline_top : int
@export var outline_bottom : int
@export var outline_right : int
@export var outline_left : int
@export_group("Offsets")
@export var right_offset : float
@export var left_offset : float
@export var shadow_offset : Vector2
@export var outline_top_offset : float
@export var outline_bottom_offset : float
@export_group("Colors")
@export var idle_color : Color = "d93b9f"
@export var hovered_color : Color = "ed40ae"
@export var shadow_color : Color = "52163c50"
@export var outline_idle_color : Color = "ed40ae"
@export var outline_hover_color : Color = "e53da8"
@export_group("Current Colors")
@export var current_button_color : Color
@export var current_outline_color : Color

@onready var button_polygon: Polygon2D = $ButtonPolygon
@onready var shadow_polygon: Polygon2D = $ButtonPolygon/ShadowPolygon
@onready var outline_polygon: Polygon2D = $ButtonPolygon/OutlinePolygon



var previous_check


func _ready() -> void:
	current_button_color = idle_color
	current_outline_color = outline_idle_color

func _process(_delta: float) -> void:
	var check = [top_distance, bottom_distance, right_offset, left_offset, flip_polygon, outline_top, outline_bottom, outline_left, outline_right, outline_top_offset, outline_bottom_offset, size]
	if check != previous_check:
		previous_check = check
		var size_x
		if top_distance > bottom_distance:
			size_x = size.x - top_distance
		else:
			size_x = size.x - bottom_distance
		button_polygon.polygon[0] = Vector2(clampf(0 + left_offset,0,size.x),0)
		button_polygon.polygon[1] = Vector2(clamp(0 + left_offset,0,size.x),size.y)
		button_polygon.polygon[2] = Vector2(clamp(size_x + bottom_distance - right_offset,0,size.x),size.y)
		button_polygon.polygon[3] = Vector2(clamp(size_x + top_distance - right_offset,0,size.x),0)
		outline_polygon.polygon[0] = Vector2(clampf(0 + left_offset,0,size.x),0)
		outline_polygon.polygon[1] = Vector2(clamp(size_x + top_distance - right_offset,0,size.x),0)
		outline_polygon.polygon[2] = Vector2(clamp(size_x + bottom_distance - right_offset,0,size.x),size.y)
		outline_polygon.polygon[3] = Vector2(clamp(0 + left_offset,0,size.x),size.y)
		outline_polygon.polygon[4] = Vector2(clampf(0 + left_offset,0,size.x),clamp(size.y - outline_bottom,0,size.y))
		outline_polygon.polygon[5] = Vector2(clamp(size_x + bottom_distance - outline_right - outline_bottom_offset - right_offset,0,size.x),clamp(size.y - outline_bottom,0,size.y))
		outline_polygon.polygon[6] = Vector2(clamp(size_x + top_distance - outline_right - outline_top_offset - right_offset,0,size.x),clamp(0 + outline_top,0,size.y))
		outline_polygon.polygon[7] = Vector2(clamp(0 + outline_left + left_offset,0,size.x),clamp(0 + outline_top,0,size.y))
		outline_polygon.polygon[8] = Vector2(clampf(0 + outline_left + left_offset,0,size.x),clamp(size.y - outline_bottom,0,size.y))
		outline_polygon.polygon[9] = Vector2(clampf(0 + left_offset,0,size.x),clamp(size.y - outline_bottom,0,size.y))
		shadow_polygon.polygon = button_polygon.polygon
		if flip_polygon:
			button_polygon.scale.x = -1
		else:
			button_polygon.scale.x = 1
		button_polygon.position.x = size.x * int(flip_polygon)
	shadow_polygon.position = shadow_offset
	shadow_polygon.color = shadow_color
	outline_polygon.color = current_outline_color
	if Engine.is_editor_hint():
		current_button_color = idle_color
		current_outline_color = outline_idle_color
	button_polygon.color = current_button_color

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if Geometry2D.is_point_in_polygon(get_local_mouse_position(),button_polygon.polygon):
			mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			mouse_filter = Control.MOUSE_FILTER_IGNORE
		if not disable_interactions:
			position.x = move_toward(position.x, target_position, 500 * delta)
		else:
			mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_mouse_entered() -> void:
	z_index = 99
	current_button_color = hovered_color
	current_outline_color = outline_hover_color
	target_position += hover_move

func _on_mouse_exited() -> void:
	if not disable_interactions:
		z_index = 0
		current_button_color = idle_color
		current_outline_color = outline_idle_color
	target_position -= hover_move


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		target_position += toggle_move
	else:
		target_position -= toggle_move


func _on_focus_entered() -> void:
	target_position += focus_move


func _on_focus_exited() -> void:
	target_position -= focus_move
