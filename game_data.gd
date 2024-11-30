extends Node

const FILE_BEGIN = "res://Levels/level"
@export var max_level: int = 3

var _ui_is_ready : bool = false
var _pending_popup : bool = false

signal show_ui_popup

func ui_ready():
	_ui_is_ready = true
	if _pending_popup:
		_pending_popup = false
		trigger_ui_popup()

func trigger_ui_popup():
	if not _ui_is_ready:
		_pending_popup = true
		return
		
	emit_signal("show_ui_popup")

func on_level_complete() -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	
	if next_level_number <= max_level:
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		call_deferred("change_level", next_level_path) # lets physics objects finish their process
	else:
		print("game over")

func change_level(scene_path):
	_ui_is_ready = false
	get_tree().change_scene_to_file(scene_path)
	_pending_popup = true

func end_game():
	get_tree().quit()
