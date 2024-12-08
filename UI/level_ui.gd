extends Control
@onready var level_text: Label = $VBoxContainer/LevelText
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# Connect to GameData and tell it we're ready to show
	SceneManager.show_ui_popup.connect(fade_in)
	SceneManager.ui_ready()
	# fade out timer
	timer.timeout.connect(_on_time_out)
	
func fade_in():
	# Get current scene path
	var current_scene_path = get_tree().current_scene.scene_file_path
	# Extract level number from path
	var level_number = current_scene_path.split("level")[1].split(".")[0]
	level_text.text = "Level " + level_number

func fade_out():
	animation_player.play("fade_out")
	
func _on_time_out():
	fade_out()
