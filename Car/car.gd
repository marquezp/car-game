extends RigidBody2D
@onready var car: RigidBody2D = $"."
@onready var click_box: Area2D = $ClickBox
@onready var charge_up: Label = $ChargeUp
@onready var charges_used: Label = $ChargesUsed

const STOP_THRESHOLD = 3.45
const STOP_FORCE = 0.9
# TODO mess around with these 2 variables when playtesting
@export var max_charge: int = 100 
@export var car_speed: int = 450
var current_charge: float = 0.0
var damping_factor: float = 0.0
var post_launch: bool = false
var selected: bool = false
var is_slowing_down: bool = false
var wheels = []

func _ready():
	# add the wheels to an array
	wheels = get_tree().get_nodes_in_group("wheel")
	# connections
	click_box.input_event.connect(_on_click_box_input_event)
	click_box.mouse_entered.connect(_on_click_box_mouse_entered)
	click_box.mouse_exited.connect(_on_click_box_mouse_exited)
	# unfreeze car + wheels
	for wheel in wheels:
		wheel.freeze = false
	self.freeze = false

# Cursor hovering on car
func _on_click_box_mouse_entered() -> void:
	print("entered")
	if not selected:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

# Cursor no longer hovering on car
func _on_click_box_mouse_exited() -> void:
	# Only change cursor if we haven't clicked yet
	#print("exited")
	if not selected:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

# car body area has been clicked, logic handled in physics_process
func _on_click_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		selected = true

func start_slowing_down(rate):
	damping_factor = rate
	is_slowing_down = true
		
func stop_slowing_down():
	is_slowing_down = false
# Apply the charge generated as torque on the wheels

func move_car(charge):
	#print("moving car")
	for wheel in wheels:
		wheel.apply_torque_impulse(charge * car_speed)
	
	current_charge = 0
	GameData.increment_charges_used()
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func slow_down_car()-> void:
	for wheel in wheels:
		#print(wheel.angular_velocity)
		if abs(wheel.angular_velocity) < STOP_THRESHOLD:
			#print("Past STOP_THRESHOLD: ")
			wheel.angular_velocity *= STOP_FORCE # Reduce speed
			if abs(wheel.angular_velocity) < 0.8: # Very slow
				#print("Past complete stop point: ")
				wheel.angular_velocity = 0 # Force complete stop
				post_launch = false
				#print("POST LAUNCH = FALSE")
				

func freeze_car() -> void:
	for wheel in wheels:
		wheel.freeze = true
	self.freeze = true

# This function handles global inputs
func _input(event):
	# mouse button released
	if selected and event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT and not event.pressed):
			selected = false # stops the car from following the cursor
			if current_charge < max_charge:
				move_car(current_charge)

func _physics_process(delta: float) -> void:
	# Handle mouse click to CHARGE UP THE CAR
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
	else: # only consider "post_launch" if the wheels are moving fast enough (gimmicky fix but w/e)
		for wheel in wheels:
			if abs(wheel.angular_velocity) > STOP_THRESHOLD:
				post_launch = true
				print("POST LAUNCH = TRUE")
			
	# Check for carpet
	if is_slowing_down:
		for wheel in wheels:
			wheel.angular_velocity *= damping_factor
			
	# Display debug info
	charge_up.text = "Charge: " + str(int(current_charge))
	charges_used.text = "Charges Used: " + str(GameData.get_charges_used())
	
