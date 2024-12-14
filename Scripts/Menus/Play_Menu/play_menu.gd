class_name PlayMenu
extends Control

@onready var load_menu: MarginContainer = $Load_Menu
@onready var main: MarginContainer = $Main
@onready var new_save: MarginContainer = $New_Save
@onready var label: Label = $New_Save/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/Label
@onready var Load: Button = $Main/VBoxContainer2/PanelContainer/VBoxContainer/Load

@export var save_file_scene : PackedScene = null
@onready var v_box_container : VBoxContainer = $Load_Menu/PanelContainer/VBoxContainer/File_List/VBoxContainer

var new_save_file : String

func _ready() -> void:
	new_save_file = SaveManager.Save_File_Get("New Game")
	label.text = "Will Be Saved As: " + new_save_file.replace("user://Saves/", "").replace(".save", "")
	for File in DirAccess.get_files_at("user://Saves"):
		SaveManager.Save_File_Load("user://Saves".path_join(File))
		var new_scene = save_file_scene.instantiate()
		v_box_container.add_child(new_scene)

func _process(_delta: float) -> void:
	if DirAccess.get_files_at("user://Saves").is_empty():
		Load.disabled = true
		if load_menu.visible:
			load_menu.visible = false
			main. visible = true
	else:
		Load.disabled = false

func _on_load_pressed() -> void:
	load_menu.visible = true
	main.visible = false
	ConsoleWindow.Print("load_load_menu", "Menu", "Output")

func _on_button_pressed() -> void:
	main.visible = true
	load_menu.visible = false
	new_save.visible = false
	ConsoleWindow.Print("load_play_menu", "Menu", "Output")

func _on_back_pressed() -> void:
	SignalBus.Emit_Exit_Play_Menu()


func _on_new_pressed() -> void:
	new_save.visible = true
	main.visible = false
	ConsoleWindow.Print("load_new_save_menu", "Menu", "Output")

func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text.is_empty():
		new_save_file = SaveManager.Save_File_Get("New Game")
		label.text = "Will Be Saved As: " + new_save_file.replace("user://Saves/", "").replace(".save", "")
	else:
		new_save_file = SaveManager.Save_File_Get(new_text)
		label.text = "Will Be Saved As: " + new_save_file.replace("user://Saves/", "").replace(".save", "")

func _on_start_pressed() -> void:
	SettingsDataContainer.save_file_data = SettingsDataContainer.default_save_file_data
	SaveManager.Save_File_Save(SettingsDataContainer.default_save_file_data.data, new_save_file, true)
	SaveManager.Save_File_Load(new_save_file)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_0.tscn")
