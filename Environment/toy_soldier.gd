extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_collider: Area2D = $AreaCollider

const SPEED = 80

var dir = 1
var parent

func _ready() -> void:
	parent = get_parent()
	area_collider.body_entered.connect(on_collision)
	
func on_collision(body):
	if body.name == "Car":
		print("Pushing back")
		body.linear_velocity.x -= 800
	
func _physics_process(delta: float) -> void:
	parent.progress += SPEED * delta * dir
	if parent.progress_ratio == 0 or parent.progress_ratio == 1:
		dir *= -1
		sprite_2d.flip_h = !sprite_2d.flip_h
