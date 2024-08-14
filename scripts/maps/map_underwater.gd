extends map

func _ready():
	
	detail_textures = [
		preload("res://assets/background_noise/rock_noise.png"),
		preload("res://assets/background_noise/rock_noise2.png"),
		preload("res://assets/background_noise/rock_noise3.png"),
	]
	props = [
		preload("res://scenes/prop_scenes/coral.tscn"),
		preload("res://scenes/prop_scenes/coral2.tscn"),
		#preload("res://scenes/prop_scenes/coral3.tscn"),
		preload("res://scenes/prop_scenes/sea_weed.tscn"),
		preload("res://scenes/prop_scenes/sea_weed2.tscn"),
		preload("res://scenes/prop_scenes/blue_rock.tscn"),
		preload("res://scenes/prop_scenes/blue_rock2.tscn"),
	]
	
	section_size = Vector2(800, 800)
	margin = 50
	
	details_section_size = Vector2i(300, 300)
	details_per_section = 2
	details_margin = 50
	
	base_ready()

## add props to the map
func base_add_props(prop_area: Vector2i, section_size: Vector2i, margin: float, border_radius: float):
	var start_position = -prop_area + (prop_area/2)

	var x: int = 0
	var y: int = 0
	var num_sections = floor((1 + (prop_area.x/section_size.x)) * (1 + (prop_area.y/section_size.y)))
	for i in num_sections:
		var num_props = 9
		if i % 4 == 0:
			num_props = 1
		for j in num_props:
			var section_position = Vector2(start_position.x + (x * (section_size.x + margin)), start_position.y + (y * (section_size.y + margin)))
			
			var prop = props[randi() % props.size()].instantiate()
			prop.add_to_group("props")
			if randi() % 2 == 0:
				prop.find_child("Sprite2D").flip_h = true
			prop.position = Vector2(section_position.x + randi() % section_size.x, section_position.y + randi() % section_size.y)
			add_child(prop)
			
		x += 1
		if x > prop_area.x/section_size.x:
			x = 0
			y += 1
