extends RigidBody2D
@onready var car: RigidBody2D = $"."
@onready var click_box: Area2D = $ClickBox
@onready var charge_up: Label = $ChargeUp
@onready var charges_used: Label = $ChargesUsed
@onready var moving_label: Label = $MovingLabel

const STOP_THRESHOLD = 34.1
const STOP_FORCE = 0.85
# TODO mess around with these 2 variables when playtesting
@export var max_charge: int = 100
@export var car_speed: int = 450
var current_charge: float = 0.0
var damping_factor: float = 0.0
var post_launch: bool = false
var is_car_moving: bool = false
var selected: bool = false
var is_slowing_down: bool = false
var wheels = []


func _ready():
	# add the wheels to an array
	wheels = get_tree().get_nodes_in_group("wheel")
	# unfreeze car + wheels
	for wheel in wheels:
		wheel.freeze = false
	self.freeze = false

func start_slowing_down(rate):
	damping_factor = rate
	is_slowing_down = true
		
func stop_slowing_down():
	is_slowing_down = false
	
# Apply the charge generated as torque on the wheels
func move_car(charge):
	print("moving car")
	for wheel in wheels:
		wheel.apply_torque_impulse(charge * car_speed)
	
	current_charge = 0
	is_car_moving = true
	GameData.increment_charges_used()
	
func slow_down_car() -> void:
	for wheel in wheels:
		if abs(car.linear_velocity.x) < STOP_THRESHOLD:
			wheel.angular_velocity *= STOP_FORCE # Reduce speed
			if abs(car.linear_velocity.x) < 1: # Very slow
				wheel.angular_velocity = 0 # Force complete stop
				

func freeze_car() -> void:
	for wheel in wheels:
		wheel.freeze = true
	self.freeze = true

# This function handles global inputs
func _input(event):
	if SceneManager.is_input_enabled(): # make sure we're accepting player input
		# Handles pause input
		if event is InputEventKey and event.keycode == KEY_ESCAPE:
			SceneManager.pause_game()
		# Handles charging (space bar)
		if event is InputEventKey and event.keycode == KEY_SPACE and !is_car_moving:
			if event.pressed and !selected:
				selected = true # Start charging
			elif not event.pressed and selected:
				selected = false # Stop charging
				move_car(current_charge)
		

func _physics_process(delta: float) -> void:
	# Handle charging up the car
	if selected:
		current_charge = min(current_charge + (50 * delta), max_charge)
		for wheel in wheels:
			wheel.get_node("AnimationPlayer").play("charge_up")

	# Charge goes over limit
	if current_charge >= max_charge:
		selected = false
		move_car(current_charge)

	# This check tells the slow_down_car() to start checking
	if post_launch:
		slow_down_car()
		if abs(car.linear_velocity.x) < 0.1:
			post_launch = false
			is_car_moving = false
	else: # only consider "post_launch" we are moving fast enough (gimmicky fix but w/e)
		if abs(car.linear_velocity.x) > STOP_THRESHOLD:
			post_launch = true
			
	# Check for carpet, post_launch check is to get the car past the STOP_THRESHOLD
	if post_launch and is_slowing_down:
		print(car.linear_velocity.x)
		for wheel in wheels:
			wheel.angular_velocity *= damping_factor
			
	# Display debug info
	moving_label.text = "Moving: " + str(is_car_moving)
	charge_up.text = "Charge: " + str(int(current_charge))
	charges_used.text = "Charges Used: " + str(GameData.get_charges_used())
