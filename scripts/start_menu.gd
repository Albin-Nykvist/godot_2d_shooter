extends Control
#
#@onready var container = $Panel/MarginContainer
#
#var screen_size = DisplayServer.screen_get_size()
#var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#container.position = screen_middle - Vector2(container.size.x/2, container.size.y/2)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
