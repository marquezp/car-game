class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton

@onready var start_level_path = "res://Levels/level1.tscn"


func _ready():
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	
func on_start_pressed():
	GameData.change_level(start_level_path)
	
func on_exit_pressed():
	GameData.end_game()
