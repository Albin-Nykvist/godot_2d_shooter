extends Item

var explosion = preload("res://scenes/hazard_scenes/poison_explosion.tscn")

func _ready():
	projectile_scene = preload("res://scenes/projectile_scenes/poison_flask_projectile.tscn")

func ability(player: Node):
	var poison_explosion = explosion.instantiate()
	poison_explosion.position = player.position
	poison_explosion.poison_duration = 4.0
	poison_explosion.scale = Vector2(2, 2)
	player.get_parent().add_child(poison_explosion)
	
	player.remove_held_item()
