extends Control

@onready var container = $Panel/MarginContainer
var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

# Called when the node enters the scene tree for the first time.
func _ready():
	container.position = screen_middle - Vector2(container.size.x/2, container.size.y/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("pause"):
		toggle()

func _on_resume_pressed():
	toggle()


func _on_options_pressed():
	pass # Replace with function body.


func _on_quit_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://start_menu.tscn")

func toggle():
	if visible:
		hide()
		get_tree().paused = false
	else:
		get_tree().paused = true
		show()

