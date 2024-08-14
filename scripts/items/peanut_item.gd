extends Item

func _ready():
	projectile_scene = preload("res://scenes/projectile_scenes/peanut_projectile.tscn")

func throw(player:Node):
	player.is_throwing = true
	player.play_sfx(player.sfx_throw)
	var angle_offset = 1.0 * PI
	for i in 2:
		var projectile = projectile_scene.instantiate()
		projectile.position = player.position 
		projectile.add_to_group("projectiles")
		projectile.look_at(player.get_global_mouse_position())
		projectile.rotate(0.5 * PI) 
		projectile.rotate(-(angle_offset*2.0) + (angle_offset * i))
		projectile.direction = Vector2.UP.rotated(projectile.rotation)
		projectile.speed = player.throw_force * 0.48
		projectile.position += projectile.direction * 50 
		player.get_parent().add_child(projectile)
		projectile.damage *= player.proj_damage_mult
		projectile.stagger *= player.proj_stagger_mult
		projectile.knockback *= player.proj_knockback_mult
		player.projectile_created.emit(projectile)
		player.camera.shake_screen(0.1, 10.0)
	
	player.is_throwing = false
	player.remove_held_item()

func ability(player: Node):
	pass
	player.remove_held_item()

