extends RigidBody2D
@onready var car: RigidBody2D = $"."
@onready var charge_up_label: Label = $ChargeUpLabel
@onready var linear_velocity_label: Label = $LinearVelocityLabel
@export var max_charge = 2000

var charge_increment = 1000
var current_charge= 0
var slow_down_rate = 0
var is_slowing_down: bool = false
var wheels = []

func start_slowing_down(rate):
	slow_down_rate = rate
	is_slowing_down = true
		
func stop_slowing_down():
	is_slowing_down = false
	
func _ready():
	wheels = get_tree().get_nodes_in_group("wheel")
	
func _input(event):
	# charge button released, apply the impulse
	if event.is_action_released("ui_accept"):
		print(current_charge)
		for wheel in wheels:
			wheel.apply_torque_impulse(current_charge * 60)
		current_charge = 0
			
func _physics_process(delta: float) -> void:
	# Charging the car
	if Input.is_action_pressed("ui_accept"):
		current_charge = move_toward(current_charge,max_charge,delta * charge_increment)
	
	# Display debug info
	charge_up_label.	text = "Charge Up: " + str(int(current_charge))
	linear_velocity_label.text = "Linear Vel: " + str(car.linear_velocity.x)
	
	# Check for carpet
	if is_slowing_down:
		car.linear_velocity.x = clamp(car.linear_velocity.x - slow_down_rate, 5, car.linear_velocity.x)
