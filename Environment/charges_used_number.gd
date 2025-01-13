extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.score_changed.connect(update_text)


func update_text():
	self.text = str(GameData.get_charges_used())
