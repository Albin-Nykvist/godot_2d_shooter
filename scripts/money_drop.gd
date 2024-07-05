extends Area2D

var particleDestroy = preload("res://scenes/particle_scenes/ParticleCoin.tscn")

@export var value = 1

func destroy():
	var particle = particleDestroy.instantiate()
	particle.position = self.position
	particle.emitting = true
	get_parent().add_child(particle)
	queue_free()
