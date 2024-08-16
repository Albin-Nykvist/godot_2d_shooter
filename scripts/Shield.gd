extends StaticBody2D

var death_particles = preload("res://scenes/vfx_scenes/ParticlePoof.tscn")

var health = 800.0

func _on_area_2d_body_entered(body):
	if body.is_in_group("projectiles") and body.position.distance_to(get_parent().position) > 200.0:
		recieve_damage(body.damage)
		body.destroy()

func recieve_damage(damage: float):
	health -= damage
	
	# tween some shit
	
	if health <= 0.0:
		var particles = death_particles.instantiate()
		particles.position = get_parent().position
		particles.scale = Vector2(1.4, 1.4)
		particles.amount = 100
		particles.lifetime = 0.35
		get_parent().get_parent().add_child(particles)
		particles.emitting = true
		queue_free()
