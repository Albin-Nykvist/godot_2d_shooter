extends Sprite2D
class_name Shadow

# Called when the node enters the scene tree for the first time.
func _ready():
	# set width and position based on parent
	var character = get_parent()
	if character is Sprite2D:
		var texture_size = character.get_texture().get_size()
		position.y = texture_size.y/2
	elif character is AnimatedSprite2D:
		var texture_size = character.sprite_frames.get_frame_texture("default", 0).get_size()
		position.y = texture_size.y/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
