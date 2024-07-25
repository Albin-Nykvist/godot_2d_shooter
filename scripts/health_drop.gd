extends Area2D


var particle_destroy = preload("res://scenes/vfx_scenes/ParticleHealth.tscn")

@export var value: float = 25.0


func destroy():
	var particle = particle_destroy.instantiate()
	particle.position = self.position
	particle.emitting = true
	get_parent().add_child(particle)
	queue_free()
