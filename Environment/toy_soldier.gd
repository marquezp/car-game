extends CharacterBody2D

const SPEED = 80

var dir = 1
var parent

func _ready() -> void:
	parent = get_parent()
	
func _physics_process(delta: float) -> void:
	if parent.name == "PathFollow2D":
		parent.progress += SPEED * delta * dir
		if parent.progress_ratio == 0 or parent.progress_ratio == 1:
			dir *= -1
