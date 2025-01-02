class_name MainMenu
extends Control

# Nav Buttons
@onready var start_button: TextureButton = $MarginContainer/OptionsContainer/StartButton
@onready var level_select_button: TextureButton = $MarginContainer/OptionsContainer/LevelSelectButton
@onready var exit_button: TextureButton = $MarginContainer/OptionsContainer/ExitButton

@onready var back_button: Button = $BackButton

# Containers
@onready var options_container: Control = $MarginContainer/OptionsContainer
@onready var level_select_container: VBoxContainer = $LevelSelectContainer
@onready var level_buttons_grid: GridContainer = $LevelSelectContainer/HBoxContainer/LevelButtonsGrid

# File/Dir Paths
@onready var start_level_path = "res://Levels/level1.tscn"
@onready var levels_folder = "res://Levels/"

# Button used for each level
const LEVEL_BUTTON = preload("res://UI/level_button.tscn")
var buttons_list = []


func _ready():
	get_levels(levels_folder)
	level_select_container.visible = false
	back_button.visible = false
	back_button.button_down.connect(on_back_pressed)
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	level_select_button.button_down.connect(on_level_select_pressed)

# MAIN OPTIONS BUTTONS ------------------
func on_start_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	SceneManager.change_level(start_level_path)

func on_level_select_pressed():
	options_container.visible = false
	level_select_container.visible = true
	back_button.visible = true
	
func on_exit_pressed():
	SceneManager.end_game()
	
# ------------------------------------------
# LEVEL SELECT BUTTONS
# Goes through the levels directory and gets all the levels
func get_levels(path):
	print(path)
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			buttons_list.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
	buttons_list.sort()
	for button in buttons_list:
		create_level_btn(button)
		
		
# Instantiates the level buttons and places them in the grid
func create_level_btn(lvl_name):
	var btn = LEVEL_BUTTON.instantiate()
	btn.text = str(lvl_name.to_int())
	level_buttons_grid.add_child(btn)
	
func on_back_pressed():
	level_select_container.visible = false
	back_button.visible = false
	options_container.visible = true
