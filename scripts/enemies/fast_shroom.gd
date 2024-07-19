extends Enemy

func _ready():
	damage = 5
	base_speed = 130.0
	speed_variation = 10.0
	speed_recovery = 0.5
	max_health = 40.0
	base_ready()

func die():
	if randi() % 100 < 25:
		var coin = coin_scene.instantiate()
		coin.position = self.position + Vector2(-10 + randi() % 21, -10)
		get_parent().add_child(coin)
	is_dead = true
	character_sprite.pause()
	shadow.hide()
