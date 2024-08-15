extends Projectile

var explosion = preload("res://scenes/hazard_scenes/poison_explosion.tscn")

var is_destroyed = false

func _ready():
	life_time = 3.0
	damage = 20.0
	knockback = 300.0
	stagger = 0.6
	speed = speed * 0.7
	base_ready()

func destroy():
	if is_destroyed: return
	is_destroyed = true
	var particles = particle_poof.instantiate()
	particles.position = self.position
	get_parent().add_child(particles)
	particles.emitting = true
	
	var poison_explosion = explosion.instantiate()
	poison_explosion.position = self.position
	get_parent().add_child(poison_explosion)
	
	queue_free()
