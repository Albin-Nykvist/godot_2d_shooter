extends CharacterBody2D
class_name Projectile

var direction = Vector2(0, 0)
var speed = 0.0
var life_time = 5.0 # minimum life time (seconds)
var time = 0
var damage = 10.0

func _physics_process(delta):
	velocity = direction * speed

	time += delta
	if time > life_time:
		queue_free()
	
	move_and_collide(velocity * delta)

func destroy():
	queue_free()
