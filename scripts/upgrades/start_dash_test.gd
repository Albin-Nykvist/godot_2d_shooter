extends Upgrade

func _ready():
	player.begin_dash.connect(_on_begin_dash)

func _on_begin_dash():
	print("start dash")
