extends Upgrade

func _ready():
	player.proj_damage_mult += player.starting_proj_damage_mult * 0.40
