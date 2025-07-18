extends Control

##List Of Badge Cards.
var badge_cards : Dictionary[String,Array]
##Badges That Are Currently Unlocked.
var unlocked_badges : Array[String]
##Badges File Path.
const BADGES_FILE_PATH = "user://badges."

func _ready() -> void:
	if FileAccess.file_exists(BADGES_FILE_PATH):
		unlocked_badges = FileAccess.open(BADGES_FILE_PATH,FileAccess.READ).get_var()

func is_locked(badge_id : String) -> bool:
	return !unlocked_badges.has(badge_id)

func award_badge(badge_id : String):
	if unlocked_badges.has(badge_id):
		return
	else:
		unlocked_badges.append(badge_id)
		FileAccess.open(BADGES_FILE_PATH,FileAccess.WRITE).store_var(unlocked_badges)
		if badge_cards[badge_id][0] != null:
			badge_cards[badge_id][0].locked = is_locked(badge_id)
			badge_cards[badge_id][0].update()

func revoke_badge(badge_id : String):
	if not unlocked_badges.has(badge_id):
		return
	else:
		unlocked_badges.erase(badge_id)
		FileAccess.open(BADGES_FILE_PATH,FileAccess.WRITE).store_var(unlocked_badges)
		if badge_cards[badge_id][0] != null:
			badge_cards[badge_id][0].locked = is_locked(badge_id)
			badge_cards[badge_id][0].update()
