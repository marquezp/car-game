extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var power_bar: Sprite2D = $PowerBar
@onready var power_needle: Sprite2D = $PowerNeedle
@onready var level_ui: Control = $UI/LevelUI

func _ready() -> void:
	level_ui.visible = true
	level_ui.find_child("TextureRect").visible = true
	power_needle.visible = false
	power_bar.visible = false
	GameData.start_charging.connect(play_charging_animation)
	GameData.start_uncharging.connect(play_uncharging_animation)
	
func play_charging_animation():
	animation_player.play("charge")
	
func play_uncharging_animation():
	animation_player.play("uncharge")
