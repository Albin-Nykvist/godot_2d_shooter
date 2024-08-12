extends map

func _ready():
	
	detail_textures = [
		
	]
	props = [
		preload("res://scenes/prop_scenes/coral.tscn"),
		preload("res://scenes/prop_scenes/coral2.tscn"),
	]
	
	section_size = Vector2(600, 600)
	margin = 50
	
	base_ready()

## add props to the map
func base_add_props(prop_area: Vector2i, section_size: Vector2i, margin: float, border_radius: float):
	var start_position = -prop_area + (prop_area/2)

	var x: int = 0
	var y: int = 0
	var num_sections = (prop_area.x/section_size.x) * (prop_area.y/section_size.y)
	for i in num_sections:
		var num_props = 4
		if randi() % 5 == 0: 
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
