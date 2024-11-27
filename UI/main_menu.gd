class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton

@onready var start_level_scene: PackedScene = preload("res://Levels/level1.tscn")


func _ready():
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	
func on_start_pressed():
	get_tree().change_scene_to_packed(start_level_scene)
	
func on_exit_pressed():
	get_tree().quit()
