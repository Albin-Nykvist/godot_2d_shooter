extends StaticBody2D

var death_particles = preload("res://scenes/vfx_scenes/ParticlePoof.tscn")

var life_time = 15.0

func _ready():
	pass

func _process(delta):
	life_time -= delta
	if life_time <= 0.0:
		var particles = death_particles.instantiate()
		particles.position = self.position
		get_parent().add_child(particles)
		particles.emitting = true
		queue_free()
