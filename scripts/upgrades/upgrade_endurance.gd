extends Upgrade

func _ready():
	player.dash_duration += player.starting_dash_duration * 0.10
	player.dash_cool_down *= 0.90
