extends Item


var delay = 0.14
var delay_counter = 0.0

var player: Node = null

var has_thown = false

var num_throws = 6
var throw_count = 0

var angle_variance = 0.025 * PI

func _ready():
	projectile_scene = preload("res://scenes/projectile_scenes/corn_piece.tscn")

func _process(delta):
	base_process(delta)
	if has_thown:
		delay_counter -= delta
		if delay_counter <= 0.0:
			throw_projectile(self.player, projectile_scene)
			throw_count += 1
			delay_counter = delay
			if throw_count >= num_throws:
				player.is_throwing = false
				player.remove_held_item()

func throw(player: Node):
	player.is_throwing = true
	if has_thown: return
	self.player = player
	throw_projectile(player, projectile_scene)
	throw_count += 1
	delay_counter = delay

func throw_projectile(player: Node, scene):
	player.play_sfx(player.sfx_throw)
	has_thown = true
	var projectile = scene.instantiate()
	projectile.position = player.position
	projectile.add_to_group("projectiles")
	projectile.look_at(player.get_global_mouse_position())
	projectile.rotate(0.5 * PI)
	#projectile.rotate(-angle_variance + fmod(randi(), angle_variance*2))
	projectile.direction = Vector2.UP.rotated(projectile.rotation)
	projectile.speed = player.throw_force
	projectile.position += projectile.direction * 50
	player.get_parent().add_child(projectile)
	player.projectile_created.emit(projectile)
	player.camera.shake_screen(0.05, 10.0)

