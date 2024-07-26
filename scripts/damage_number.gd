extends Node2D

@onready var label = $Label

var value = 0

var life_time = 0.75
var time = 0

var speed: Vector2
var start_position_y = 0

var gravity = 10

func _ready():
	var rand_x = 50
	speed = Vector2(-rand_x + randi() % (rand_x*2), -280)
	label.text = str(value)
	scale = Vector2.ZERO
	start_position_y = position.y

func _process(delta):
	time += delta
	if time >= life_time:
		queue_free()
	
	scale.x += 0.06
	scale.y += 0.06
	if scale.x > 1.0:
		scale.x = 1.0
		scale.y = 1.0
	
	position += speed * delta
	speed.y += gravity
	#if start_position_y - 50 > position.y:
		#position.y = start_position_y - 50
