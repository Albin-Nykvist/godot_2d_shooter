extends Control
var arrow_cursor = load("res://assets/cursor_arrow.png")

func _ready():
	DisplayServer.cursor_set_custom_image(arrow_cursor)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
