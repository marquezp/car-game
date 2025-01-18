class_name MainMenu
extends Control

# Nav Buttons
@onready var start_button: TextureButton = $OptionsContainer/StartButton
@onready var level_select_button: TextureButton = $OptionsContainer/LevelSelectButton
@onready var exit_button: TextureButton = $OptionsContainer/ExitButton
@onready var credits_button: TextureButton = $OptionsContainer/CreditsButton

@onready var back_button: TextureButton = $BackButton
@onready var level_buttons_grid: GridContainer = $LevelSelectContainer/LevelButtonsGrid
@onready var game_title: TextureRect = $GameTitle

# Containers
@onready var options_container: Control = $OptionsContainer
@onready var level_select_container: Control = $LevelSelectContainer


# File/Dir Paths
@onready var start_level_path = "res://Levels/level1.tscn"
@onready var levels_folder = "res://Levels/"

# Button used for each level
const LEVEL_BUTTON = preload("res://UI/level_button.tscn")
var buttons_list = []
const button_sprites_path = "res://Assets/Buttons/levelButtons/"

@onready var car: RigidBody2D = $Car


func _ready():
	get_levels(levels_folder)
	level_select_container.visible = false
	back_button.visible = false
	back_button.button_down.connect(on_back_pressed)
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	level_select_button.button_down.connect(on_level_select_pressed)

# MAIN OPTIONS BUTTONS ------------------
func on_start_pressed():
	SoundFx.button_click()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	SceneManager.change_level(start_level_path)
	SoundFx.game_theme()

func on_level_select_pressed():
	SoundFx.button_click()
	game_title.visible = false
	options_container.visible = false
	level_select_container.visible = true
	back_button.visible = true
	
func on_exit_pressed():
	SceneManager.end_game()

func on_credits_pressed():
	SoundFx.button_click()
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
	
	# Normal State
	var normal_image_path = button_sprites_path + str(lvl_name.to_int()) + "Basic.png"
	var normal_texture = load(normal_image_path)  # load used to get a resource
	
	# Hover State
	var hover_image_path = button_sprites_path + str(lvl_name.to_int()) + "Highlight.png"
	var hover_texture = load(hover_image_path)  # load used to get a resource
	
	#Check if textures loaded successfully
	if normal_texture == null:
		print("Error: Failed to load normal texture from path: ", normal_image_path)
		return
	if hover_texture == null:
		print("Error: Failed to load hover texture from path: ", hover_image_path)
		return
		
	# Add textures to the button
	btn.texture_normal = normal_texture
	btn.texture_hover = hover_texture
	
	# Attach corresponding level
	btn.level = str(lvl_name.to_int())
	
	# Add to the grid
	level_buttons_grid.add_child(btn)
	
func on_back_pressed():
	SoundFx.back_button_click()
	game_title.visible = true
	level_select_container.visible = false
	back_button.visible = false
	options_container.visible = true
