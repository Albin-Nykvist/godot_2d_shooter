extends Node2D

@export var player: Node = null

var round_time = 300
var time = 300

var maps = [
	preload("res://scenes/world.tscn")
]

var enemy_team_spawners = [
	preload("res://scenes/enemy_team_spawner_scenes/mushroom_spawner_1.tscn")
]

func reset():
	get_tree().reload_current_scene()

func _process(delta):
	time -= delta
	player.time_label.text = "%02d:%02d" % [time/60, fmod(time, 60)]
	if time <= 0.0:
		level_cleared()
		time = round_time

func level_cleared():
	for child in self.get_children():
		if !child.is_in_group("players") and !child.is_in_group("item_spawner"):
			remove_child(child)
			child.queue_free()
	
	for child in player.get_children():
		if child.is_in_group("map_particle"):
			remove_child(child)
			child.queue_free()
	
	new_level()


func new_level():
	# add in a world scene
	var map = maps[randi() % maps.size()].instantiate()
	add_child(map)

	# set player in middle
	player.position = Vector2.ZERO
	
	# add a level spawner (do not use the old spawner for this, but make a new one)
	var enemy_team_spawner = enemy_team_spawners[randi() % enemy_team_spawners.size()].instantiate()
	enemy_team_spawner.player = self.player
	enemy_team_spawner.game = self
	add_child(enemy_team_spawner)
	enemy_team_spawner.enable()
