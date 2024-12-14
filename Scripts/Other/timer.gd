extends Label

@onready var time = SettingsDataContainer.save_file_data.data.player.time

var msec : int = 000
var sec : int = 00
var min : int = 00
var hour : int = 00

func _process(delta: float) -> void:
	time += delta
	if Global.timer:
		msec = fmod(time, 1) * 1000
		sec = fmod(time, 60)
		min = fmod(time,3600) / 60
		hour = fmod(time, 360000) / 3600
		text = "%02d:%02d:%02d.%03d" % [hour, min, sec, msec]
		visible = true
	else:
		visible = false
	SettingsDataContainer.save_file_data.data.player.time = time

func stop() -> void:
	set_process(false)

func start() -> void:
	set_process(true)

func reset() -> void:
	time = 0.0
	SettingsDataContainer.save_file_data.data.player.time = time
