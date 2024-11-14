extends RigidBody2D
@onready var car: RigidBody2D = $"."

@export var speed = 10000
var wheels = []

func _ready():
	wheels = get_tree().get_nodes_in_group("wheel")
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		for wheel in wheels:
			wheel.apply_torque_impulse(speed * delta * 60)
