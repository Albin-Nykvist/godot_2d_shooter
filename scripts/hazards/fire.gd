extends StaticBody2D

var smoke = preload("res://scenes/vfx_scenes/ParticleFireOut.tscn")

@onready var side_flame = $SideFlames
@onready var center_flame = $CenterFlame

@export var life_time = 7
var time = 0.0

var is_reduced = false

func _process(delta):
	time += delta
	
	if time >= life_time * 0.7 and is_reduced == false:
		is_reduced = true
		side_flame.initial_velocity_max *= 0.5
		center_flame.initial_velocity_max *= 0.5
	elif time >= life_time:
		var particle = smoke.instantiate()
		particle.position = self.position
		particle.emitting = true
		get_parent().add_child(particle)
		queue_free()
