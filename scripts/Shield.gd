extends StaticBody2D

var death_particles = preload("res://scenes/vfx_scenes/ParticlePoof.tscn")

@export var health = 400.0

var rotation_direction = 0
var rotation_speed = 0
func _ready():
	if randi() % 2 == 0:
		rotation_direction = 1
	else:
		rotation_direction = -1

func _on_area_2d_body_entered(body):
	if body.is_in_group("projectiles"):
		recieve_damage(body.damage)
		body.destroy()

func recieve_damage(damage: float):
	health -= damage
	
	# tween some shit
	
	if health <= 0.0: # do a death state and let the particles play out before freeing
		var particles = death_particles.instantiate()
		particles.position = get_parent().position
		particles.scale = Vector2(1.4, 1.4)
		particles.amount = 100
		particles.lifetime = 0.35
		add_child(particles)
		particles.emitting = true
		queue_free()

func _process(delta):
	pass
	$Sprite2D.rotate(rotation_speed * PI * delta * rotation_direction)
