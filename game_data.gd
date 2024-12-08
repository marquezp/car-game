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
	
	call_deferred("end_level_sequence")
	
	if next_level_number <= max_level:
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		
		await get_tree().create_timer(2.0).timeout # wait until triggering next scene
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		call_deferred("change_level", next_level_path) # lets physics objects finish their process
	else:
		print("Game Over, Total Charges Used: " , total_score)
		
# 	
func end_level_sequence():
	var car = get_tree().current_scene.get_node("Car")
	var confetti_list = get_tree().get_nodes_in_group("confetti")
	for color in confetti_list:
		color.emitting = true
	#var camera = get_tree().current_scene.get_node("Camera2D")
	#var tween = create_tween()
	# Vector2 is zoom distance, float is speed (smaller = faster) 
	#tween.tween_property(camera, "zoom", Vector2(2, 2), 0.4)  
	#tween.parallel().tween_property(camera, "position", car.position, 0.3) # camera follows car
	
	car.freeze_car() # stop movement
	
		
# Scene transitions
func change_level(scene_path):
	ui_is_ready = false
	get_tree().change_scene_to_file(scene_path)
	pending_popup = true

func end_game():
	get_tree().quit()
