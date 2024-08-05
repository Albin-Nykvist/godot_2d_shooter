extends Item

@onready var speed_boost_scene = preload("res://scenes/temp_upgrade_scenes/temp_speed.tscn")

func _ready():
	projectile_scene = preload("res://scenes/projectile_scenes/coffee_drop.tscn")

func throw(player: Node):
	player.is_throwing = true
	player.play_sfx(player.sfx_throw)
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
		projectile.damage *= player.proj_damage_mult
		projectile.stagger *= player.proj_stagger_mult
		projectile.knockback *= player.proj_knockback_mult
		player.projectile_created.emit(projectile)
		player.camera.shake_screen(0.1, 10.0)
	
	player.is_throwing = false
	player.remove_held_item()


# add more visual elemements:
# yellow tint
# particles from player
# yellow particles like the leaf_particles but more like bubbles
func ability(player: Node):
	if is_ability_triggered: return
	is_ability_triggered = true
	
	var temp_speed = speed_boost_scene.instantiate()
	temp_speed.player = player
	temp_speed.speed_boost = 175.0
	temp_speed.life_time = 8.0
	player.add_child(temp_speed)
	
	var label = text_popup_scene.instantiate()
	label.life_time = 1.0
	label.gravity = 5
	label.start_speed_y = -150
	var rand = randi() % 5
	if rand == 0:
		label.text = "COFFEE!"
	elif rand == 1:
		label.text = "GULP!"
	elif rand == 2:
		label.text = "FULL SPEED!"
	elif rand == 3:
		label.text = "CAFFEINATED!"
	elif rand == 4:
		label.text = "COFFEE POWER!"

	label.position = player.position
	player.get_parent().add_child(label)
	
	player.camera.shake_screen(1.0, 4)
	
	player.remove_held_item()
