extends Item

#var second_shot_delay = 0.17
var second_shot_delay = 0.12
var delay_counter = 0.0

var player: Node = null

var has_thown = false

var second_projectile_scene = preload("res://scenes/projectile_scenes/sock2.tscn")

func _ready():
	projectile_scene = preload("res://scenes/projectile_scenes/sock.tscn")

func _process(delta):
	base_process(delta)
	if has_thown:
		delay_counter -= delta
		if delay_counter <= 0.0:
			throw_projectile(self.player, second_projectile_scene)
			player.is_throwing = false
			player.remove_held_item()

func throw(player: Node):
	player.is_throwing = true
	if has_thown: return
	self.player = player
	throw_projectile(player, projectile_scene)
	delay_counter = second_shot_delay

func throw_projectile(player: Node, scene):
	player.play_sfx(player.sfx_throw)
	has_thown = true
	var projectile = scene.instantiate()
	projectile.position = player.position #+ item_sprite.position
	projectile.add_to_group("projectiles")
	projectile.look_at(player.get_global_mouse_position())
	projectile.rotate(0.5 * PI) # Why this quarter rotation is necessary is beond me
	projectile.direction = Vector2.UP.rotated(projectile.rotation)
	projectile.speed = player.throw_force
	projectile.position += projectile.direction * 50 # nice initial offset
	player.get_parent().add_child(projectile)
	player.camera.shake_screen(0.05, 10.0)

