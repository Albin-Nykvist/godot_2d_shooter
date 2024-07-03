extends Node2D

var item_scene = preload("res://scenes/item.tscn")
var enemy_scene = preload("res://scenes/enemy.tscn")

@onready var player = $Player
@onready var pause_menu = $PauseMenu

var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

var item_spawn_rate = 9.0 # Once every x seconds
var item_spawn_rate_counter = 0.0
var item_spawn_amount = 3
const MAX_ITEMS = 20

var enemy_wave_rate = 20.0 # Once every x seconds
var enemy_wave_rate_counter = 0.0
var enemy_wave_size = 7
const MAX_ENEMIES = 50

func _ready():
	player.position = screen_middle
	
	for i in range(0, 5):
		spawn_enemy()
		spawn_item()

func _process(delta):
	item_spawn_rate_counter += delta
	var num_items = get_tree().get_nodes_in_group("items").size()
	if item_spawn_rate_counter > item_spawn_rate and num_items < MAX_ITEMS:
		item_spawn_rate_counter = 0
		spawn_items()
	elif num_items <= 0:
		spawn_item()
	
	enemy_wave_rate_counter += delta
	var num_enemies = get_tree().get_nodes_in_group("enemies").size()
	if enemy_wave_rate_counter > enemy_wave_rate and num_enemies < MAX_ENEMIES:
		enemy_wave_rate_counter = 0
		spawn_enemy_wave()
	
	$TimeRemaining.text = str(round($GameTimer.time_left))

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
	var screen_edge_offset = 150
	
	# Lets have the enemies spawn on a circle around the player
	# we need: desired distance to player, random angle, converting the angle and distance to a vector
	var distance_to_player = (screen_size.x/2) + screen_edge_offset
	var random_unit_vector = Vector2.UP.rotated(randf() * 2 * PI)
	enemy.position = player.position + random_unit_vector.normalized() * distance_to_player 

func spawn_item():
	var item = item_scene.instantiate()
	add_child(item)
	item.add_to_group("items")
	item.position = player.position - Vector2(-(screen_size.x/2) + randi() % screen_size.x, -(screen_size.y/2) + randi() % screen_size.y)

func spawn_items():
	#item_spawn_amount += item_spawn_amount * 0.5
	for i in range(0, item_spawn_amount):
		spawn_item()

func reset(): # you can do something like, resetscene, i believe
	get_tree().reload_current_scene()


func _on_game_timer_timeout():
	pass
