extends CharacterBody2D
class_name Projectile

@onready var particle_poof = preload("res://scenes/particle_scenes/ParticlePoof.tscn")
@onready var particle_flight = preload("res://scenes/particle_scenes/ParticleProjectile.tscn")

var direction = Vector2(0, 0)
var speed = 0.0
var life_time = 5.0 # minimum life time (seconds)
var time = 0
var damage = 80.0

func _ready():
	base_ready()

func base_ready():
	var particles = particle_flight.instantiate()
	particles.position += Vector2(0, 40)
	add_child(particles)
	particles.emitting = true

func _physics_process(delta):
	velocity = direction * speed

	time += delta
	if time > life_time:
		queue_free()
	
	move_and_collide(velocity * delta)

func destroy():
	var particles = particle_poof.instantiate()
	particles.position = self.position
	get_parent().add_child(particles)
	particles.emitting = true
	queue_free()
