extends StaticBody2D

@export var life_time = 10
var time = 0.0

@onready var sprite = $Sprite2D
@onready var shadow = $Shadow


var shadow_start_scale = Vector2.ZERO
var shadow_end_scale = Vector2.ZERO


func _ready():
	if randi() % 2 == 0:
		sprite.flip_h = true
	if randi() % 2 == 0:
		scale.x += 0.2
	if randi() % 2 == 0:
		scale.y += 0.2
	
	shadow_start_scale = shadow.scale
	shadow_end_scale = shadow_start_scale * 1.3

func _process(delta):
	time += delta
	
	shadow.scale += shadow_end_scale / 1400
	if shadow.scale.x > shadow_end_scale.x:
		shadow.scale.x = shadow_end_scale.x
	if shadow.scale.y > shadow_end_scale.y:
		shadow.scale.y = shadow_end_scale.y
	
	if time >= life_time:
		queue_free()

