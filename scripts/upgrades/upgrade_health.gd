extends Upgrade

var health_increase = 25.0

func _ready():
	player.max_health += health_increase
	player.health += health_increase
	player.update_health_ui()
