extends Control

@onready var continue_button: Button = $HBoxContainer/VBoxContainer/ContinueButton
@onready var restart_button: Button = $HBoxContainer/VBoxContainer/RestartButton
@onready var main_menu_button: Button = $HBoxContainer/VBoxContainer/MainMenuButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	self.visible = false
	SceneManager.show_pause_menu.connect(pause)
	continue_button.pressed.connect(_on_continue_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_pressed)

func pause():
	animation_player.play("blur")
	self.visible = true
	get_tree().paused = true
	print("pausing")
	
func resume():
	animation_player.play_backwards("blur")
	self.visible = false
	get_tree().paused = false
	print("unpausing")
	
# Button Connections
func _on_continue_pressed():
	resume()

func _on_restart_pressed():
	resume()
	SceneManager.reset_level()
	
func _on_main_pressed():
	resume()
	SceneManager.reset_game()
