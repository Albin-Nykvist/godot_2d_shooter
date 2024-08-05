extends Node2D

# Attach to player node

@export var player: Node = null

var life_time = 12.0
var time = 0.0

var speed_boost = 100.0

func _ready():
	player.speed += speed_boost
	player.target_speed += speed_boost

func _process(delta):
	time += delta
	if time >= life_time:
		player.speed -= speed_boost
		player.target_speed -= speed_boost
		queue_free()
