extends Node2D


@onready var particle_poof = preload("res://scenes/vfx_scenes/ParticlePoof.tscn")

var fire_scene = preload("res://scenes/hazard_scenes/fire.tscn")

@onready var sprite = $Sprite2D

const explode_time = 6.0
var time = 0.0

var blink_delay = 0.5
var blink_delay_counter = 0.5

func _ready():
	scale = Vector2(0.9, 0.9)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), explode_time).set_trans(Tween.TRANS_LINEAR)

func _process(delta):
	time += delta
	if time >= explode_time:
		explode()
	
	if time >= explode_time * 0.5:
		blink_delay_counter -= delta
		if blink_delay_counter <= 0.0:
			blink_delay -= 0.05
			blink_delay_counter = blink_delay
			sprite.modulate = Color(100, 100, 100)
			var tween = get_tree().create_tween()
			tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.1).set_trans(Tween.TRANS_LINEAR)

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
