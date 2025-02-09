extends Label

@onready var time = SettingsDataContainer.save_file_data.data.player.time

var msec : float = 00
var sec : float = 00
@warning_ignore("shadowed_global_identifier")
var min : float = 00
var hour : float = 00

func _process(delta: float) -> void:
	time += delta
	if SettingsDataContainer.Storage_Dict.accsesability.timer_visible:
		msec = fmod(time, 1) * 100
		sec = fmod(time, 60)
		min = fmod(time,3600) / 60
		hour = fmod(time, 360000) / 3600
		text = "%02d:%02d:%02d.%02d" % [hour, min, sec, msec]
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("timer_show"):
		SettingsDataContainer.Storage_Dict.accsesability.timer_visible = !SettingsDataContainer.Storage_Dict.accsesability.timer_visible
		ConsoleWindow.Print("save_options_data: %s" % SettingsDataContainer.Storage_Dict, "Save", "Output")
		SaveManager.Save_Data(SettingsDataContainer.Storage_Dict, "Settings")
