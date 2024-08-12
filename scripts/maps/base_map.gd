extends Node2D
class_name map

@export var player: Node

@onready var background = $Background

var map_border_scene = preload("res://scenes/prop_scenes/map_edge.tscn")
var detail = preload("res://scenes/noise.tscn")

var detail_textures = [
	preload("res://assets/background_noise/grass_noise.png"),
	preload("res://assets/background_noise/grass_noise2.png"),
	preload("res://assets/background_noise/flower_noise.png"),
]

var props = [
	preload("res://scenes/prop_scenes/rock1.tscn"),
	preload("res://scenes/prop_scenes/rock2.tscn"),
	preload("res://scenes/prop_scenes/bush2.tscn"),
	preload("res://scenes/prop_scenes/bush.tscn"),
	preload("res://scenes/prop_scenes/tree3.tscn"),
	preload("res://scenes/prop_scenes/tree3.tscn"),
	preload("res://scenes/prop_scenes/tree3.tscn"),
]

var border_radius = 2000.0
var map_area = Vector2i(5000.0, 5000.0)
var section_size = Vector2i(400, 400)
var details_section_size = Vector2i(400, 400)
var margin = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	base_ready()

func base_ready():
	base_create_border(border_radius, 25)
	base_add_props(map_area, section_size, margin, border_radius)
	base_add_background_details(map_area, details_section_size, 0, border_radius, 4)


## make a perimiter for the map with a border scene
func base_create_border(border_radius: float, num_scenes: int): 
	var angle = 0.0 * PI
	var angle_increment = (2.0 * PI) / num_scenes 
	for i in num_scenes:
		var scene = map_border_scene.instantiate()
		scene.add_to_group("map_edge")
		scene.get_node("Sprite2D").self_modulate = background.modulate.darkened(0.15)
		scene.position = Vector2.UP.rotated(angle) * border_radius
		scene.rotate(angle)
		add_child(scene)
		angle += angle_increment 

## add props to the map
func base_add_props(prop_area: Vector2i, section_size: Vector2i, margin: float, border_radius: float):
	var start_position = -prop_area + (prop_area/2)

	var x: int = 0
	var y: int = 0
	var num_sections = (prop_area.x/section_size.x) * (prop_area.y/section_size.y)
	for i in num_sections:
		var section_position = Vector2(start_position.x + (x * (section_size.x + margin)), start_position.y + (y * (section_size.y + margin)))
		
		var prop = props[randi() % props.size()].instantiate()
		prop.add_to_group("props")
		if randi() % 2 == 0:
			prop.find_child("Sprite2D").flip_h = true
		prop.position = Vector2(section_position.x + randi() % section_size.x, section_position.y + randi() % section_size.y)
		add_child(prop)
		
		#if prop.position.distance_to(self.position) > border_radius:
			#prop.get_node("Sprite2D").modulate.darkened(0.2)
		
		x += 1
		if x > prop_area.x/section_size.x:
			x = 0
			y += 1


func base_add_background_details(area: Vector2i, section_size: Vector2i, margin: float, border_radius: float, details_per_section: int):
	if detail_textures.is_empty(): return
	
	var start_position = -area + (area/2)
	var x: int = 0
	var y: int = 0
	var num_sections = (area.x/section_size.x) * (area.y/section_size.y)
	for i in num_sections:
		for j in details_per_section:
			var section_position = Vector2(start_position.x + (x * (section_size.x + margin)), start_position.y + (y * (section_size.y + margin)))
			
			var detail = self.detail.instantiate()
			detail.z_index = -1
			detail.texture = detail_textures[randi() % detail_textures.size()]
			detail.self_modulate.a = randf_range(0.095, 0.15)
			detail.position = Vector2(section_position.x + randi() % section_size.x, section_position.y + randi() % section_size.y)
			if randi() % 2 == 0:
				detail.flip_h = true
			add_child(detail)
			
		
		x += 1
		if x > area.x/section_size.x:
			x = 0
			y += 1
