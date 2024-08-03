extends Projectile

var snow_scene = preload("res://scenes/hazard_scenes/snow.tscn")

var is_destroyed = false

func _ready():
	life_time = 3.5
	damage = 40.0
	knockback = 400.0
	stagger = -1.0
	speed = speed * 0.7
	base_ready()

func destroy():
	if is_destroyed: return
	is_destroyed = true
	var particles = particle_poof.instantiate()
	particles.position = self.position
	get_parent().add_child(particles)
	particles.emitting = true
	
	var distance = 60
	var amount = 25
	var shift = 20
	for i in amount:
		var pos = self.position + Vector2.UP.rotated(fmod(randi(), 2 * PI)) * distance
		pos.x += -shift + randi() % (shift * 2)
		pos.y += -shift + randi() % (shift * 2)
		place_snow(pos)
	
	queue_free()

func place_snow(pos: Vector2):
	var snow = snow_scene.instantiate()
	snow.position = pos
	snow.life_time = 13 + fmod(randi(), 0.5)
	get_parent().add_child(snow)
