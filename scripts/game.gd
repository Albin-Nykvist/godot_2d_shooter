extends Node2D

@onready var player = $Player

var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

func _ready():
	player.position = screen_middle

func reset():
	get_tree().reload_current_scene()
