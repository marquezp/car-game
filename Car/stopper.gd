extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(on_car_entered)
	

func on_car_entered(body):
	if body.name == "Car":
		call_deferred("freeze", body)
		body.linear_velocity.x = 0
		call_deferred("unfreeze",body)

func freeze(body):
	body.freeze_car()
	
func unfreeze(body):
	body.unfreeze()
