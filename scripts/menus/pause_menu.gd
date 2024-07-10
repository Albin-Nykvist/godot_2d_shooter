extends Control

@onready var container = $MarginContainer
var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

var arrow_cursor = load("res://assets/cursor/cursor_arrow.png")

func _ready():
	# This garbage can not be centered by default, so this is centering for you 
	position = position - (screen_size/2.0)
	
	# Also, but more understandably center the container (there is probably a better way to do this)
	container.position = screen_middle - Vector2(container.size.x/2, container.size.y/2)

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		toggle()

func _on_resume_pressed():
	toggle()


func _on_options_pressed():
	pass # Replace with function body.


func _on_quit_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_scenes/start_menu.tscn")

func toggle():
	if visible:
		get_tree().paused = false
		hide()
	else:
		DisplayServer.cursor_set_custom_image(arrow_cursor)
		get_tree().paused = true
		show()

