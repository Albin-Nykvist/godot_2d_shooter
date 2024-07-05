extends Node2D

var prop_scene = preload("res://scenes/prop_scenes/rock1.tscn")
var prop2_scene = preload("res://scenes/prop_scenes/rock2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# spawn some props
	var prop_area = Vector2i(8000, 8000)
	var prop_area_position = -prop_area + (prop_area/2)
	var section_size = Vector2i(400, 400)
	var x: int = 0
	var y: int = 0
	var margin = 100
	for i in (prop_area.x/section_size.x) * (prop_area.y/section_size.y):
		var section_position = Vector2(prop_area_position.x + (x * (section_size.x + margin)), prop_area_position.y + (y * (section_size.y + margin)))
		var prop = prop_scene.instantiate()
		if randi() % 2 == 0:
			prop = prop2_scene.instantiate()
		prop.position = Vector2(section_position.x + randi() % section_size.x, section_position.y + randi() % section_size.y)
		add_child(prop)
		x += 1
		if x > prop_area.x/section_size.x:
			x = 0
			y += 1

