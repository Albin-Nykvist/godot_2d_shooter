extends Enemy

func _ready():
	damage = 5
	base_speed = 140.0
	speed_variation = 10.0
	speed_recovery = 0.5
	max_health = 40.0
	base_ready()
