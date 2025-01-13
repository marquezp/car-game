extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var power_bar: Sprite2D = $PowerBar
@onready var power_needle: Sprite2D = $PowerNeedle


func _ready() -> void:
	power_needle.visible = false
	power_bar.visible = false
	GameData.start_charging.connect(play_charging_animation)
	GameData.start_uncharging.connect(play_uncharging_animation)
	
func play_charging_animation():
	animation_player.play("charge")
	
	
func play_uncharging_animation():
	#var animation = animation_player.get_animation("uncharge")
	#var track_index = animation.add_track(Animation.TYPE_VALUE)
	#animation.track_set_path(track_index, "PowerNeedle:rotation")
	#
	#var initial_angle = rad_to_deg(power_needle.rotation)
	#var distance_to_start = abs(-90 - initial_angle)
	#var second_angle = initial_angle - (distance_to_start * 0.5)
	## Insert animation keys
	#animation.track_insert_key(track_index, 0.0, deg_to_rad(initial_angle))
	#animation.track_insert_key(track_index, 0.333, deg_to_rad(second_angle))
	#animation.track_insert_key(track_index, 0.666, deg_to_rad(-90))
	animation_player.play("uncharge")
