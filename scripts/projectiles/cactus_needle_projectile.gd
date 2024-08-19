extends Projectile

func _ready():
	damage = 10.0
	knockback = 50.0
	stagger = 0.8
	life_time = 0.45 + fmod(randi(), 0.10)

func destroy():
	#var particles = particle_poof.instantiate()
	#particles.position = self.position
	#get_parent().add_child(particles)
	#particles.emitting = true
	
	queue_free()
