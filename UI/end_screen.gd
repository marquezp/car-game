extends Control

@onready var main_menu_button: TextureButton = $MainMenuBody/MainMenuButton
@onready var credits_button: TextureButton = $CreditsBall/CreditsButton
@onready var ball: RigidBody2D = $CreditsBall
@onready var main_menu_body: RigidBody2D = $MainMenuBody

func _ready() -> void:
	main_menu_button.pressed.connect(main_menu)
	credits_button.pressed.connect(show_credits)
	ball.angular_velocity += 67
	main_menu_body.angular_velocity -= 50
	
func show_credits():
	SceneManager.credits()
	
func main_menu():
	SceneManager.reset_game()
