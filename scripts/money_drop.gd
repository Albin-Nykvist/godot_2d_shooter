extends Area2D

@onready var shadow = $Sprite2D/Shadow

var particleDestroy = preload("res://scenes/vfx_scenes/ParticleCoin.tscn")

@export var value = 1

var is_moving = false
var move_duration = 1.0
var move_duration_counter = 0.0
var speed : Vector2
var stop_position_y = 0.0
var speed_gravity = 18
var start_rand_speed_x = 120
var start_speed_y = -500

var start_scale = Vector2(0.5, 0.5)
var scale_rate = 1.0

func _ready():
	set_moving()

func _process(delta):
	if is_moving:

		scale.x += scale_rate * delta
		scale.y += scale_rate * delta
		if scale.x > 1.0:
			scale.x = 1.0
			scale.y = 1.0
		
		position += speed * delta
		speed.y += speed_gravity
		
		if position.y > stop_position_y and speed.y > 0.0:
			set_idle()
		
		move_duration_counter -= delta
		if move_duration_counter <= 0.0:
			set_idle()

func set_moving():
	speed = Vector2(-start_rand_speed_x + randi() % (start_rand_speed_x*2), start_speed_y)
	scale = start_scale
	stop_position_y = position.y - 25 + randi() % 100
	shadow.visible = false
	z_index = 1
	move_duration_counter = move_duration
	is_moving = true

func set_idle():
	is_moving = false
	shadow.visible = true
	z_index = 0
	position.y = stop_position_y
	scale = Vector2(1, 1)

func destroy():
	var particle = particleDestroy.instantiate()
	particle.position = self.position
	particle.emitting = true
	get_parent().add_child(particle)
	queue_free()
