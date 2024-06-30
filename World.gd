extends Node2D

var item_scene = preload("res://item.tscn")
var enemy_scene = preload("res://enemy.tscn")

@onready var player = $Player
@onready var camera = $Camera

var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

var item_spawn_rate = 9.0 # Once every x seconds
var item_spawn_rate_counter = 0.0
const MAX_ITEMS = 20

var enemy_spawn_rate = 20.0 # Once every x seconds
var enemy_spawn_rate_counter = 0.0
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
		for i in range(0, 3):
			spawn_item()
	elif num_items <= 0:
		spawn_item()
	
	enemy_spawn_rate_counter += delta
	var num_enemies = get_tree().get_nodes_in_group("enemies").size()
	if enemy_spawn_rate_counter > enemy_spawn_rate and num_enemies < MAX_ENEMIES:
		enemy_spawn_rate_counter = 0
		for i in range(0, 5):
			spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.add_to_group("enemies")
	enemy.attack_target = player
	var r = 0 + randi() % 4
	var screen_edge_offset = 10
	if r == 0:
		enemy.position = Vector2(-screen_edge_offset, randi() % screen_size.y)
	elif r == 1:
		enemy.position = Vector2(screen_size.x + screen_edge_offset, randi() % screen_size.y)
	elif r == 2:
		enemy.position = Vector2(randi() % screen_size.x, -screen_edge_offset)
	elif r == 3:
		enemy.position = Vector2(randi() % screen_size.x, screen_size.y + screen_edge_offset)

func spawn_item():
	var item = item_scene.instantiate()
	add_child(item)
	item.add_to_group("items")
	item.position = Vector2(screen_middle.x + (-400 + randi() % 800), screen_middle.y + (-300 + randi() % 600))

func reset(): # you can do something like, resetscene, i believe
	pass
