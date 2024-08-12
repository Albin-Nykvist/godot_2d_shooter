extends Upgrade

var spawner_scene = preload("res://scenes/spawner.tscn")

@export var item_scene : PackedScene = null

func _ready():
	var spawner = spawner_scene.instantiate()
	spawner.entity_scene = item_scene
	spawner.player = player
	spawner.entity_is_item = true
	spawner.min_spawn_distance_to_player = 50
	spawner.max_spawn_distance_to_player = 500
	spawner.spawn_node = player.get_parent()
	spawner.spawn_group = "items"
	spawner.wave_rate = 12
	spawner.wave_size = 1
	spawner.wave_size_growth = 0
	spawner.spawn_wave_on_ready = true
	spawner.max_number_of_entities = 3
	spawner.add_to_group("item_spawner")
	player.get_parent().add_child(spawner)
