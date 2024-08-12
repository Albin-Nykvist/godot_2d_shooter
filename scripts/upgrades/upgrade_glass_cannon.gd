extends Upgrade

func _ready():
	player.proj_damage_mult += player.starting_proj_damage_mult * 0.50
	player.max_health -= player.starting_max_health * 0.2
	if player.max_health <= 0.0:
		player.max_health = 1.0
	if player.health > player.max_health:
		player.health = player.max_health
