extends Area2D

const FILE_BEGIN = "res://Levels/level"
@export var max_level: int = 3

func _ready():
	connect("body_entered", self._on_body_entered)

func _on_body_entered(body):
	# script that handles end of stage
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	
	if next_level_number <= max_level and body.name == "Car":		
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		call_deferred("change_level", next_level_path) # lets physics objects finish their process
	else:
		print("game over")
		
func change_level(scene_path):
	get_tree().change_scene_to_file(scene_path)
	
