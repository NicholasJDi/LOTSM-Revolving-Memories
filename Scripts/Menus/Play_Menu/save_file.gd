class_name SaveFile 
extends Control

@onready var label: Label = $HBoxContainer/VBoxContainer/Label/Label
@onready var date_created: Label = $HBoxContainer/VBoxContainer/Data/Date_Created
@onready var last_played: Label = $HBoxContainer/VBoxContainer/Data/Last_Played
@onready var time_played: Label = $"HBoxContainer/VBoxContainer/Data/Time Played"
@onready var save_path = SettingsDataContainer.save_file_data.file.location
@onready var time = SettingsDataContainer.save_file_data.data.player.time

func _ready() -> void:
	label.text = str(SettingsDataContainer.save_file_data.file.location).replace(".save","").replace("user://Saves/","").capitalize()
	date_created.text = "Date Created: " + SettingsDataContainer.save_file_data.file.date_created
	last_played.text = "Last Played: " + SettingsDataContainer.save_file_data.file.last_played
	time_played.text = "Time Played: %02d:%02d:%02d.%03d" % [fmod(time, 216000) / 3600, fmod(time,3600) / 60, fmod(time, 60), fmod(time, 1) * 1000]

func _on_load_pressed() -> void:
	SaveManager.Save_File_Load(save_path)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_" + SettingsDataContainer.save_file_data.data.player.level + ".tscn")


func _on_delete_pressed() -> void:
	DirAccess.remove_absolute(save_path)
	self.queue_free()
