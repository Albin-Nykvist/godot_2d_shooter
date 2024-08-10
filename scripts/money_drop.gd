extends Area2D

@onready var shadow = $Sprite2D/Shadow
@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D
@onready var particles = $CPUParticles2D

var landing_particles = preload("res://scenes/vfx_scenes/ParticleGroundHit.tscn")

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

var is_falling = false
var fall_speed = 300
var fall_speed_variation = 200
var fall_acceleration = 1.05
var initial_offset = 1500
var initial_sprite_position: float
var initial_shadow_position: float


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
	if is_falling:
		fall_from_sky(delta)

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

func fall_from_sky(delta: float):
	sprite.position.y += fall_speed * delta
	fall_speed *= fall_acceleration
	
	if sprite.position.y > initial_sprite_position:
		set_to_grounded()

func set_to_grounded():
	sprite.position.y = initial_sprite_position
	shadow.visible = true
	particles.visible = true
	is_falling = false
	collider.disabled = false
	var particles_landing = landing_particles.instantiate()
	add_child(particles_landing)
	particles_landing.position = Vector2(0, -20)
	particles_landing.emitting = true
	
	set_moving()
	scale = Vector2(1, 1)

func set_to_falling():
	fall_speed += -fall_speed_variation + fmod(randi(), fall_speed_variation*2)
	initial_sprite_position = sprite.position.y
	initial_shadow_position = shadow.position.y
	collider.disabled = true
	sprite.position.y -= initial_offset
	shadow.visible = false
	particles.visible = false
	is_falling = true
