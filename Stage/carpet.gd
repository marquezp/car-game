extends Area2D

# TODO mess around with this factor when playtesting
@export var damping_factor: float = 0.7

func _ready():
	connect("body_entered", self._on_body_entered)
	connect("body_exited", self._on_body_exited)

func _on_body_entered(body):
	# Send the message to start slowing down
	if body.name == "Car" and body.has_method("start_slowing_down"):
		body.start_slowing_down(damping_factor)
		print("entered carpet")

func _on_body_exited(body):
	# Send the message to stop slowing down
	if body.name == "Car" and body.has_method("stop_slowing_down"):
		body.stop_slowing_down()
		print("passed carpet")
