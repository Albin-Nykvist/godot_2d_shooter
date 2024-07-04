extends Node2D

var item_scene = preload("res://scenes/item.tscn")
var enemy_scene = preload("res://scenes/enemy.tscn")
var prop_scene = preload("res://scenes/prop_scenes/rock1.tscn")
var prop2_scene = preload("res://scenes/prop_scenes/rock2.tscn")

@onready var player = $Player
@onready var background_sprite = $Background

var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

var item_spawn_rate = 9.0 # Once every x seconds
var item_spawn_rate_counter = 0.0
var item_spawn_amount = 3
const MAX_ITEMS = 20

var enemy_wave_rate = 8.0 # Once every x seconds
var enemy_wave_rate_counter = 0.0
var enemy_wave_size = 7
const MAX_ENEMIES = 50

func _ready():
	player.position = screen_middle
	
	for i in range(0, 5):
		spawn_enemy()
		spawn_item()
	
	# spawn some props
	var prop_area = Vector2i(8000, 8000)
	var prop_area_position = -prop_area + (prop_area/2)
	var section_size = Vector2i(400, 400)
	var x: int = 0
	var y: int = 0
	var margin = 100
	for i in (prop_area.x/section_size.x) * (prop_area.y/section_size.y):
		var section_position = Vector2(prop_area_position.x + (x * (section_size.x + margin)), prop_area_position.y + (y * (section_size.y + margin)))
		var prop = prop_scene.instantiate()
		if randi() % 2 == 0:
			prop = prop2_scene.instantiate()
		prop.position = Vector2(section_position.x + randi() % section_size.x, section_position.y + randi() % section_size.y)
		add_child(prop)
		x += 1
		if x > prop_area.x/section_size.x:
			x = 0
			y += 1

func _process(delta):
	item_spawn_rate_counter += delta
	
	var item_near_player = false
	for item in get_tree().get_nodes_in_group("items"):
		if item.position.distance_to(player.position) < 800:
			item_near_player = true
	
	if item_near_player == false:
		spawn_item()
	
	var num_items = get_tree().get_nodes_in_group("items").size()
	if item_spawn_rate_counter > item_spawn_rate and num_items < MAX_ITEMS:
		item_spawn_rate_counter = 0
		spawn_items()
	#elif num_items <= 0:
		#spawn_item()
	
	enemy_wave_rate_counter += delta
	var num_enemies = get_tree().get_nodes_in_group("enemies").size()
	if enemy_wave_rate_counter > enemy_wave_rate and num_enemies < MAX_ENEMIES:
		enemy_wave_rate_counter = 0
		spawn_enemy_wave()
	

func spawn_enemy_wave():
	#enemy_wave_size += enemy_wave_size * 0.5
	for i in range(0, enemy_wave_size):
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.add_to_group("enemies")
	enemy.attack_target = player
	var r = 0 + randi() % 4
	#var screen_edge_offset = 150
	#var distance_to_player = (screen_size.x/2) + screen_edge_offset
	var distance_to_player = 1500
	var random_unit_vector = Vector2.UP.rotated(randf() * 2 * PI)
	enemy.position = player.position + random_unit_vector.normalized() * distance_to_player 

func spawn_item():
	var item = item_scene.instantiate()
	add_child(item)
	item.set_to_falling()
	item.add_to_group("items")
	var distance_to_player = 100 + randi() % 500
	var random_unit_vector = Vector2.UP.rotated(randf() * 2 * PI)
	item.position = player.position + random_unit_vector.normalized() * distance_to_player 


func spawn_items():
	#item_spawn_amount += item_spawn_amount * 0.5
	for i in range(0, item_spawn_amount):
		spawn_item()

func reset():
	get_tree().reload_current_scene()
