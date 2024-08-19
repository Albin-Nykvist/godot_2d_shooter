extends Item

var cactus_hazard_scene = preload("res://scenes/hazard_scenes/cactus_hazard.tscn")

func _ready():
	projectile_scene = preload("res://scenes/projectile_scenes/cactus_projectile.tscn")

func ability(player: Node):
	var cactus = cactus_hazard_scene.instantiate()
	cactus.position = player.position 
	cactus.look_at(player.get_global_mouse_position())
	cactus.rotate(0.5 * PI) # Why this quarter rotation is necessary is beond me
	var direction = Vector2.UP.rotated(cactus.rotation)
	cactus.position += direction * 60 # nice initial offset'
	cactus.rotation = 0
	player.get_parent().add_child(cactus)
	
	player.camera.shake_screen(0.5, 5)
	
	player.remove_held_item()
