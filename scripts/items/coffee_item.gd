extends Item

func _ready():
	projectile_scene = preload("res://scenes/projectile_scenes/coffee_drop.tscn")


func throw(player: Node):
	player.is_throwing = true
	
	var angle_offset = 0.05 * PI
	for i in 5:
		var projectile = projectile_scene.instantiate()
		projectile.position = player.position 
		projectile.add_to_group("projectiles")
		projectile.look_at(player.get_global_mouse_position())
		projectile.rotate(0.5 * PI) 
		projectile.rotate(-(angle_offset*2.0) + (angle_offset * i))
		projectile.direction = Vector2.UP.rotated(projectile.rotation)
		projectile.speed = player.throw_force * 0.56
		projectile.position += projectile.direction * 50 
		player.get_parent().add_child(projectile)
		player.camera.shake_screen(0.1, 10.0)
	
	player.is_throwing = false
	player.remove_held_item()
