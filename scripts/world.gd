extends Node2D

var map_edge_scene = preload("res://scenes/prop_scenes/map_edge.tscn")
var noise = preload("res://scenes/noise.tscn")

var noise_textures = [
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

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# make a perimiter for the map with a prop
	var edge_radius = 4000
	var num_scenes = 25
	var angle = 0.0 * PI
	var angle_increment = (2.0 * PI) / num_scenes 
	for i in num_scenes:
		var scene = map_edge_scene.instantiate()
		scene.add_to_group("map_edge")
		scene.position = Vector2.UP.rotated(angle) * edge_radius
		scene.rotate(angle)
		add_child(scene)
		angle += angle_increment 
	
	
	
	# spawn some props
	var prop_area = Vector2i(8000, 8000)
	var prop_area_position = -prop_area + (prop_area/2)
	var section_size = Vector2i(400, 400)
	var x: int = 0
	var y: int = 0
	var margin = 100
	var num_sections = (prop_area.x/section_size.x) * (prop_area.y/section_size.y)
	for i in num_sections:
		var section_position = Vector2(prop_area_position.x + (x * (section_size.x + margin)), prop_area_position.y + (y * (section_size.y + margin)))
		var prop = props[randi() % props.size()].instantiate()
		prop.add_to_group("props")
		if randi() % 2 == 0:
			prop.find_child("Sprite2D").flip_h = true
		prop.position = Vector2(section_position.x + randi() % section_size.x, section_position.y + randi() % section_size.y)
		add_child(prop)
		
		for j in 4:
			var noise = self.noise.instantiate()
			noise.z_index = -1
			noise.texture = noise_textures[randi() % noise_textures.size()]
			noise.self_modulate.a = randf_range(0.095, 0.15)
			noise.position = Vector2(section_position.x + randi() % section_size.x, section_position.y + randi() % section_size.y)
			if randi() % 2 == 0:
				noise.flip_h = true
			add_child(noise)
		
		x += 1
		if x > prop_area.x/section_size.x:
			x = 0
			y += 1
		
		# Could not make the map edge remove props, but this is the same
		if prop.position.distance_to(self.position) > edge_radius:
			remove_child(prop)

