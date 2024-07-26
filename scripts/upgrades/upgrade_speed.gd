extends Upgrade

func _ready():
	player.speed += player.starting_speed * 0.15
	player.target_speed = player.speed
