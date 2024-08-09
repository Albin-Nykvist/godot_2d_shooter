extends Item

var bomb_scene = preload("res://scenes/hazard_scenes/lamp_bomb.tscn")

func _ready():
	projectile_scene = preload("res://scenes/projectile_scenes/lamp_projectile.tscn")

func ability(player: Node):
	var bomb = bomb_scene.instantiate()
	bomb.position = player.position
	player.get_parent().add_child(bomb)
	
	player.camera.shake_screen(0.5, 5)
	
	player.remove_held_item()
