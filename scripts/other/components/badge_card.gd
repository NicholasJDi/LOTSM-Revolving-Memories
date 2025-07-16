@tool
extends Control

@export var badge : Badge
@export var locked : bool
@export var id : String

@onready var badge_icon: TextureRect = $"VBoxContainer/Icon&NameSection/VBoxContainer/Icon"
@onready var badge_name: Label = $"VBoxContainer/Icon&NameSection/VBoxContainer/Name"
@onready var badge_description: RichTextLabel = $VBoxContainer/Description

var last_locked : bool

func _ready() -> void:
	if badge != null and not Engine.is_editor_hint():
		BadgeManager.badge_cards[badge.id] = self
	update()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or locked != last_locked:
		update()
		last_locked = locked

func update() -> void:
	if badge == null:
		badge_icon.texture = load("res://icon.svg")
		badge_name.text = "Badge Name"
		badge_description.text = "Badge Description"
		return
	else:
		if not locked:
			badge_icon.texture = badge.icon
			badge_name.text = badge.display_name
			badge_description.text = badge.description
