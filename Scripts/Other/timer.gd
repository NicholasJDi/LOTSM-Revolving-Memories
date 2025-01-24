extends Label

@onready var time = SettingsDataContainer.save_file_data.data.player.time

var msec : float = 000
var sec : float = 00
var min : float = 00
var hour : float = 00

func _process(delta: float) -> void:
	time += delta
	if Global.timer:
		msec = fmod(time, 1) * 10
		sec = fmod(time, 60)
		min = fmod(time,3600) / 60
		hour = fmod(time, 360000) / 3600
		text = "%02d:%02d:%02d.%01d" % [hour, min, sec, msec]
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
