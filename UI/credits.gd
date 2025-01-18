extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("scroll")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			SceneManager.reset_game()
			
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			SceneManager.reset_game()
