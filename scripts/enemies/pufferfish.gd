extends Enemy

var poof_scene = preload("res://scenes/vfx_scenes/ParticlePoof.tscn")

var has_morphed = false
var morph_health = 0.5

func _ready():
	base_speed = 105.0
	speed_variation = 15.0
	speed_recovery = 4.0
	max_health = 450.0
	base_ready()

func recieve_damage_after():
	if !has_morphed and health <= max_health * morph_health:
		morph()

func morph():
	start_speed += 40.0
	speed_recovery *= 0.5
	max_health *= morph_health
	
	var particle_poof = poof_scene.instantiate()
	particle_poof.position = self.position
	get_parent().add_child(particle_poof)
	particle_poof.emitting = true
	
	character_sprite.play("morphed")
