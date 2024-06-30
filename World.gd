extends Node2D

var item_scene = preload("res://item.tscn")
var enemy_scene = preload("res://enemy.tscn")

@onready var player = $Player

var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

var item_spawn_rate = 3.0 # Once every x seconds
var item_spawn_rate_counter = 0.0

var enemy_spawn_rate = 4.0 # Once every x seconds
var enemy_spawn_rate_counter = 0.0

func _ready():
	# Move player and throwable into place
	
	player.position = screen_middle



func _process(delta):
	item_spawn_rate_counter += delta
	if item_spawn_rate_counter > item_spawn_rate:
		item_spawn_rate_counter = 0
		var item = item_scene.instantiate()
		add_child(item)
		item.add_to_group("items")
		#item.position = Vector2(300 + randi() % (screen_size.x-300), 300 + randi() % (screen_size.y-300))
		item.position = Vector2(screen_middle.x + (-300 + randi() % 600), screen_middle.y + (-300 + randi() % 600))
	
	enemy_spawn_rate_counter += delta
	if enemy_spawn_rate_counter > enemy_spawn_rate:
		enemy_spawn_rate_counter = 0
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
		enemy.add_to_group("enemies")
		#item.position = Vector2(300 + randi() % (screen_size.x-300), 300 + randi() % (screen_size.y-300))
		enemy.attack_target = player
		
		#enemy.position
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

func reset():
	pass
