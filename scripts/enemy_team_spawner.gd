extends Node2D
class_name EnemyTeamSpawner

@export var enabled = false

@export var game: Node = null
@export var player: Node = null

func _ready():
	for child in self.get_children():
		if child.is_in_group("spawner"):
			child.spawn_node = game
			child.player = player
			child.spawn_group = "enemies"
			child.spawner_group = child.name
			child.enabled = true


func enable():
	self.enabled = true
	for child in self.get_children():
		if child.is_class("Spawner"):
			child.enabled = true

func dissable():
	self.enabled = false
	for child in self.get_children():
		if child.is_class("Spawner"):
			child.enabled = false
