extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.mouse_entered.connect(on_hover)
	
	if texture_normal:
		# Get the image from the texture normal
		var image = texture_normal.get_image()
		# Create the BitMap
		var bitmap = BitMap.new()
		# Fill it from the image alpha
		bitmap.create_from_image_alpha(image)
		# Assign it to the mask
		texture_click_mask = bitmap
		

func on_hover():
	SoundFx.level_button_hover()
