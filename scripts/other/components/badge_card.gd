@tool
extends Control

@export var badge : Badge
@export var locked : bool
@export var id : float

@onready var badge_icon: TextureRect = $"VBoxContainer/Icon&NameSection/VBoxContainer/Icon"
@onready var badge_name: Label = $"VBoxContainer/Icon&NameSection/VBoxContainer/Name"
@onready var badge_description: RichTextLabel = $VBoxContainer/Description

var last_locked : bool

var locked_badge = {
	"icon" : load("res://icon.svg"),
	"display_name" : "???",
	"description" : "You Cannot Veiw This Badges Description Until It Has Been Unlocked."
}

func _ready() -> void:
	if badge != null and not Engine.is_editor_hint():
		BadgeManager.badge_cards[badge.id] = [self, badge]
		locked = BadgeManager.is_locked(badge.id)
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
		if not locked or badge.locked_visibility == "Icon Name & Description":
			badge_icon.texture = badge.icon
			badge_name.text = badge.display_name
			badge_description.text = badge.description
		elif badge.locked_visibility == "Icon & Name":
			badge_icon.texture = badge.icon
			badge_name.text = badge.display_name
			badge_description.text = locked_badge.description
		elif badge.locked_visibility == "Name":
			badge_icon.texture = locked_badge.icon
			badge_name.text = badge.display_name
			badge_description.text = locked_badge.description
		elif badge.locked_visibility == "Icon":
			badge_icon.texture = badge.icon
			badge_name.text = locked_badge.display_name
			badge_description.text = locked_badge.description
		else:
			badge_icon.texture = locked_badge.icon
			badge_name.text = locked_badge.display_name
			badge_description.text = locked_badge.description
