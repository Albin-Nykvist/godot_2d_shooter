extends Area2D


@onready var shadow = $Sprite2D/Shadow

var particle_destroy = preload("res://scenes/vfx_scenes/ParticleHealth.tscn")

@export var value: float = 25.0


var is_moving = false
var move_duration = 1.0
var move_duration_counter = 0.0
var speed = Vector2(0, -500)
var deacceleration = 0.98
var rotation_direction = 1.0

var start_scale = Vector2(0.75, 0.75)
var scale_rate = 1.0

func _ready():
	if randi() % 2 == 0:
		rotation_direction = -1.0
	speed = speed.rotated(fmod(randi(), 2.0 * PI))
	set_moving()

func _process(delta):
	if is_moving:

		scale.x += scale_rate * delta
		scale.y += scale_rate * delta
		if scale.x > 1.0:
			scale.x = 1.0
			scale.y = 1.0
		
		position += speed * delta
		speed = speed.rotated(2.0 * PI * delta * rotation_direction) * deacceleration
		
		move_duration_counter -= delta
		if move_duration_counter <= 0.0:
			set_idle()

func set_moving():
	scale = start_scale
	shadow.visible = false
	z_index = 1
	move_duration_counter = move_duration
	is_moving = true

func set_idle():
	is_moving = false
	shadow.visible = true
	z_index = 0
	scale = Vector2(1, 1)



func destroy():
	var particle = particle_destroy.instantiate()
	particle.position = self.position
	particle.emitting = true
	get_parent().add_child(particle)
	queue_free()
