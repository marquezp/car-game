extends Node

const FILE_BEGIN = "res://Levels/level"
const MAIN_MENU_PATH = "res://UI/main_menu.tscn"
const LEVEL_SELECT_PATH = "res://UI/level_select.tscn"
@export var max_level: int = 9

var ui_is_ready : bool = false
var pending_popup : bool = false
var input_enabled : bool = true

signal show_ui_popup
signal show_pause_menu

func is_input_enabled():
	return input_enabled
	
func pause_game():
	emit_signal("show_pause_menu")
	
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
	input_enabled = false
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	
	call_deferred("end_level_sequence")
	
	if next_level_number <= max_level:
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		
		await get_tree().create_timer(2.0).timeout # wait until triggering next scene
		
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		call_deferred("change_level", next_level_path) # lets physics objects finish their process
		
	else: # Last level, game over
		print("Game Over, Total Charges Used: " , GameData.charges_used)
# 	
func end_level_sequence():
	var car = get_tree().current_scene.get_node("Car")
	var confetti_list = get_tree().get_nodes_in_group("confetti")
	for color in confetti_list:
		color.emitting = true
	
	car.freeze_car() # stop movement

func show_level_select():
	get_tree().change_scene_to_file(LEVEL_SELECT_PATH)
	
# Scene transitions
func change_level(scene_path):
	ui_is_ready = false
	get_tree().change_scene_to_file(scene_path)
	pending_popup = true
	input_enabled = true

func reset_level():
	get_tree().reload_current_scene()
	
func reset_game():
	GameData.charges_used = 0
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
	
func end_game():
	get_tree().quit()
