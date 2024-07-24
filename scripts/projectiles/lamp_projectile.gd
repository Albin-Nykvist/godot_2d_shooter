extends Projectile

var fire_scene = preload("res://scenes/hazard_scenes/fire.tscn")

func _ready():
	life_time = 3.5
	damage = 10.0
	knockback = 250.0
	stagger = 1.0
	speed = speed * 0.8
	base_ready()

func destroy():
	var particles = particle_poof.instantiate()
	particles.position = self.position
	get_parent().add_child(particles)
	particles.emitting = true
	
	var distance = 120
	place_fire(self.position)
	for i in 4:
		place_fire(self.position + Vector2.UP.rotated(fmod(randi(), 2*PI)) * (40 + randi() % (distance - 40)))
	
	queue_free()

func place_fire(pos: Vector2):
	var fire = fire_scene.instantiate()
	fire.position = pos
	fire.life_time = 7.5
	get_parent().add_child(fire)
