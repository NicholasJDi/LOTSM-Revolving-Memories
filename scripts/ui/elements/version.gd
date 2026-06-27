extends Label

## The format to use, the [member text] will be set to this with %version% replaced with the version defined in project settings.
@export var format : String = "Version: %version%"

func _ready() -> void:
	var v = ProjectSettings.get_setting("application/config/version")
	text = format.replace("%version%", v)
