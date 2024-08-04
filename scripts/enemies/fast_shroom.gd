extends Enemy

func _ready():
	damage = 5
	base_speed = 160.0
	speed_variation = 10.0
	speed_recovery = 2.0
	max_health = 40.0
	base_ready()
