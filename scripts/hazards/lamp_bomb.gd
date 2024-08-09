extends Node2D


@onready var particle_poof = preload("res://scenes/vfx_scenes/ParticlePoof.tscn")

var fire_scene = preload("res://scenes/hazard_scenes/fire.tscn")

@onready var sprite = $Sprite2D

var explode_time = 6.0
var time = 0.0

func _ready():
	scale = Vector2(0.9, 0.9)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), explode_time).set_trans(Tween.TRANS_LINEAR)

func _process(delta):
	time += delta
	if time >= explode_time:
		explode()

func explode():
	var particles = particle_poof.instantiate()
	particles.position = self.position
	get_parent().add_child(particles)
	particles.emitting = true
	
	var distance = 180
	place_fire(self.position)
	for i in 7:
		place_fire(self.position + Vector2.UP.rotated(fmod(randi(), 2*PI)) * (40 + randi() % (distance - 40)))
	
	queue_free()

func place_fire(pos: Vector2):
	var fire = fire_scene.instantiate()
	fire.position = pos
	fire.life_time = 8.0 + fmod(randi(), 6.0)
	get_parent().add_child(fire)
