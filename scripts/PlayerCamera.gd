extends Camera2D

@export var enable_shake = true

# screen shake
var is_shaking: bool = false
var shake_duration: float = 0.0
var shake_duration_counter = 0.0
var shake_max_offset: float = 0.0

func _process(delta):
	if is_shaking and enable_shake:
		if shake_duration_counter > 0.0:
			shake_duration_counter -= delta
			self.offset.x = -shake_max_offset + fmod(randi(), shake_max_offset*2)
			self.offset.y = -shake_max_offset + fmod(randi(), shake_max_offset*2)
		else:
			self.offset = Vector2.ZERO

func shake_screen(duration: float, max_offset: float):
	shake_duration = duration
	shake_duration_counter = shake_duration
	shake_max_offset = max_offset
	is_shaking = true
