extends TextureButton
const FILE_BEGIN = "res://Levels/level"
var original_size := scale
var grow_size := Vector2(1.1, 1.1)
var level : int

func _ready():
	self.pressed.connect(_on_pressed)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _on_pressed():
	SoundFx.button_click()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	SceneManager.change_level(FILE_BEGIN + str(level) + ".tscn")
	SoundFx.game_theme()
	
func _on_mouse_entered():
	SoundFx.level_button_hover()
	grow_btn(grow_size, .1)

func _on_mouse_exited():
	grow_btn(original_size, .1)
	
func grow_btn(end_size, duration):
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'scale', end_size, duration)
	
	
