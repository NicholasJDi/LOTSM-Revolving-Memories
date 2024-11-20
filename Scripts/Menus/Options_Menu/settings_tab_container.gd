class_name Settings_Tab_Container
extends Control

@onready var tab_container: TabContainer = $TabContainer
@onready var options_menu: OptionsMenu = $"../../.."


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		if tab_container.current_tab >= tab_container .get_tab_count() -2:
			tab_container.current_tab = 0
			return
		tab_container.current_tab = tab_container.current_tab + 1
	if event.is_action_pressed("ui_left"):
		if tab_container.current_tab == 0:
			tab_container.current_tab = tab_container .get_tab_count() -2
			return
		tab_container.current_tab = tab_container.current_tab - 1
	if event.is_action_pressed("ui_cancel") and options_menu.visible:
		SignalBus.Emit_Exit_Options_Menu_External()
