extends Node

const FILE_BEGIN = "res://Levels/level"
@export var max_level: int = 4

var charges_used : int = 0 : set = set_charges_used, get = get_charges_used
var total_score: int = 0
var ui_is_ready : bool = false
var pending_popup : bool = false

signal show_ui_popup

func set_charges_used(value: int) -> void:
	charges_used = value
	print(charges_used) 

func get_charges_used() -> int:
	return charges_used
	
func increment_charges_used():
	charges_used += 1
	
# Called by level_ui's _ready() function, tells us the UI scene has loaded
func ui_ready():
	ui_is_ready = true
	if pending_popup:
		pending_popup = false
		trigger_ui_popup()

func trigger_ui_popup():
	if not ui_is_ready:
		pending_popup = true
		return
		
	emit_signal("show_ui_popup")

# Handles switching between levels
func on_level_complete() -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	total_score += charges_used
	charges_used = 0
	if next_level_number <= max_level:
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		call_deferred("change_level", next_level_path) # lets physics objects finish their process
	else:
		print("Game Over, Total Charges Used: " , total_score)
		

# Scene transitions
func change_level(scene_path):
	ui_is_ready = false
	get_tree().change_scene_to_file(scene_path)
	pending_popup = true

func end_game():
	get_tree().quit()
