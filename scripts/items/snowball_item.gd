extends Item

var snow_scene = preload("res://scenes/hazard_scenes/snow.tscn")

func _ready():
	projectile_scene = preload("res://scenes/projectile_scenes/snowball_projectile.tscn")

func ability(player: Node):
	var min_distance = 120
	var max_distance = 140
	var angle = 0.0
	var num_snow = 30
	var angle_increment = (2.0 * PI) / num_snow
	var rand_x = 10
	
	for i in num_snow:
		var distance = min_distance + randi() % (max_distance - min_distance)
		place_snow(player, Vector2(-rand_x + fmod(randi(), rand_x * 2.0), -distance).rotated(angle))
		angle += angle_increment
	
	player.remove_held_item()

func place_snow(player: Node, pos: Vector2):
	var snow = snow_scene.instantiate()
	snow.position = player.position + pos
	snow.life_time = 7.5
	player.get_parent().add_child(snow)
