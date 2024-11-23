extends Area2D

@onready var game: Node = $".."

func _ready():
	connect("body_entered", self._on_body_entered)

func _on_body_entered(body):
	# notify game script to handle end of stage
	if body.name == "Car":
		game.stage_over()
