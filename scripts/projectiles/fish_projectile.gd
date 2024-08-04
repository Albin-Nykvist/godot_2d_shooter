extends Projectile

func _ready():
	damage = 200.0
	knockback = 650.0
	life_time = 1.0
	speed = speed * 0.6
	for i in 5:
		var particles = particle_flight.instantiate()
		particles.position -= Vector2(30, 30)
		add_child(particles)
		particles.emitting = true

func _process(delta):
	rotate(-0.08 * PI)
