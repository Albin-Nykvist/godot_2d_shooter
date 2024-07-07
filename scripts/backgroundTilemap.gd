extends TileMap

func _ready():
	for x in 100:
		for y in 100:
			set_cell(0, Vector2i(x, y), 1, Vector2i(randi() % 4, randi() % 2), 0)
