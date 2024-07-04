extends CharacterBody2D
class_name Projectile

@onready var poof = preload("res://scenes/particle_scenes/ParticlePoof.tscn")

var direction = Vector2(0, 0)
var speed = 0.0
var life_time = 5.0 # minimum life time (seconds)
var time = 0
var damage = 50.0

func _physics_process(delta):
	velocity = direction * speed

	time += delta
	if time > life_time:
		queue_free()
	
	var before_position = self.position
	move_and_collide(velocity * delta)

func destroy():
	var poof = poof.instantiate()
	poof.position = self.position
	get_parent().add_child(poof)
	poof.emitting = true
	queue_free()
