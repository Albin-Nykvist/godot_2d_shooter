extends Upgrade

var percent_chance = 50

var projectile_scene = preload("res://scenes/projectile_scenes/sock.tscn")
var projectile_scene2 = preload("res://scenes/projectile_scenes/sock2.tscn")

var delay_max = 0.3
var delay_counter = 0.0

func _ready():
	player.begin_dash.connect(_on_begin_dash)

func _on_begin_dash():
	if randi() % 100 < percent_chance:
		delay_counter = fmod(randf(), delay_max)

func _process(delta):
	if delay_counter > 0.0:
		delay_counter -= delta
		if delay_counter <= 0.0:
			throw()

func throw():
	var projectile = projectile_scene.instantiate()
	if randi() % 2 == 0:
		projectile = projectile_scene2.instantiate()
	projectile.position = player.position
	projectile.add_to_group("projectiles")
	projectile.look_at(player.get_global_mouse_position())
	projectile.rotate(0.5 * PI) # Why this quarter rotation is necessary is beond me
	projectile.direction = Vector2.UP.rotated(projectile.rotation)
	projectile.speed = player.throw_force
	projectile.position += projectile.direction * 50 # nice initial offset
	player.get_parent().add_child(projectile)
	projectile.damage *= player.proj_damage_mult
	projectile.stagger *= player.proj_stagger_mult
	projectile.knockback *= player.proj_knockback_mult
	player.projectile_created.emit(projectile)
	player.camera.shake_screen(0.05, 10.0)
