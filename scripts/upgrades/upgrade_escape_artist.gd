extends Upgrade

var speed_boost = preload("res://scenes/temp_upgrade_scenes/temp_speed.tscn")

func _ready():
	player.pick_up.connect(_on_pick_up)

func _on_pick_up():
	var boost = speed_boost.instantiate()
	boost.speed_boost = 80.0
	boost.life_time = 2.0
	boost.player = player
	player.add_child(boost)
