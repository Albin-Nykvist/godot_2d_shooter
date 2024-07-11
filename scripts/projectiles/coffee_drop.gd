extends Projectile

var coffee_color = Color(0.1, 0.05, 0.0)

var scale_reduction = 1.2

func _ready():
	life_time = 0.4
	damage = 45.0
	stagger = 0.1
	knockback = 250.0
	
	var particles = particle_flight.instantiate()
	particles.modulate = coffee_color
	particles.amount = 20
	particles.emission_sphere_radius = 25
	particles.scale_amount_max = 20
	particles.position += Vector2(0, 10)
	add_child(particles)
	particles.emitting = true

func _process(delta):
	self.scale = Vector2(self.scale.x - (scale_reduction * delta), self.scale.y - (scale_reduction * delta))

func destroy():
	var particles = particle_poof.instantiate()
	particles.modulate = coffee_color
	particles.scale_amount_max = 30
	particles.lifetime = 0.2
	particles.initial_velocity_max = 200
	particles.position = self.position
	get_parent().add_child(particles)
	particles.emitting = true
	queue_free()
