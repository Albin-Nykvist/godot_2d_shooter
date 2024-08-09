extends StaticBody2D

@export var life_time = 10.0
var time = 0.0

@onready var sprite = $Sprite2D
@onready var shadow = $Shadow

func _ready():
	if randi() % 2 == 0:
		sprite.flip_h = true
	if randi() % 2 == 0:
		scale.x += 0.2
	if randi() % 2 == 0:
		scale.y += 0.2
	
	life_time += randi() % 3
	
	var tween = get_tree().create_tween()
	tween.tween_property(shadow, "scale", shadow.scale * 1.4, 2.5)
	tween.tween_callback(Callable(self, "more_melt"))
	

func _process(delta):
	time += delta
	
	if time >= life_time * 0.9:
		sprite.visible = false
	
	if time >= life_time:
		queue_free()

func more_melt():
	var tween = get_tree().create_tween()
	tween.tween_property(shadow, "scale", shadow.scale * 1.1, 10.0)
