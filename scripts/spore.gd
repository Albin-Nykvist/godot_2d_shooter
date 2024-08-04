extends StaticBody2D

@onready var particle_spore = preload("res://scenes/vfx_scenes/spore_particles.tscn")

@export var life_time = 8
var time = 0.0

var is_particle_added = false

func _process(delta):
	time += delta
	
	if time >= life_time * 0.7 and !is_particle_added:
		is_particle_added = true
		var particle = particle_spore.instantiate()
		particle.position = self.position
		particle.one_shot = true
		particle.emitting = true
		get_parent().add_child(particle)
	elif time >= life_time:
		queue_free()
