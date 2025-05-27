extends Label

@onready var time : float = 0

var msec : float = 00
var sec : float = 00
@warning_ignore("shadowed_global_identifier")
var min : float = 00
var hour : float = 00

func _process(delta: float) -> void:
	time += delta
	msec = fmod(time, 1) * 100
	sec = fmod(time, 60)
	min = fmod(time,3600) / 60
	hour = fmod(time, 360000) / 3600
	text = "%02d:%02d:%02d.%02d" % [hour, min, sec, msec]

func stop() -> void:
	set_process(false)

func start() -> void:
	set_process(true)

func reset() -> void:
	time = 0.0
