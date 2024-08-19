extends Projectile

var projectile_scene = preload("res://scenes/projectile_scenes/cactus_needle_projectile.tscn")

var needle_delay = 0.35
var needle_delay_counter = 0.0
var needle_random_rotation = 0.15 * PI

func _ready():
	damage = 50.0
	knockback = 100.0
	stagger = 0.4
	life_time = 2.5
	speed = speed * 0.4

func _physics_process(delta):
	velocity = direction * speed
	time += delta
	if time > life_time:
		destroy()
	
	needle_delay_counter -= delta
	if needle_delay_counter <= 0.0:
		shoot_needles()
		needle_delay_counter = needle_delay
	
	move_and_collide(velocity * delta)

func shoot_needles():
	for i in 16:
		var projectile = projectile_scene.instantiate()
		projectile.position = self.position
		projectile.add_to_group("projectiles")
		projectile.rotation = self.rotation
		if i % 2 == 0:
			projectile.rotate(0.5 * PI)
		else:
			projectile.rotate(-0.5 * PI)
		projectile.rotate(-needle_random_rotation + fmod(randi(), (needle_random_rotation*2.0)))
		projectile.direction = Vector2.UP.rotated(projectile.rotation)
		projectile.speed = 500 + randi() % 200
		projectile.position += projectile.direction * 20
		get_parent().add_child(projectile)
		projectile.damage = self.damage * 0.2
