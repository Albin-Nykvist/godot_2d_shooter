extends Upgrade

func _ready():
	player.start_dash.connect(_on_start_dash)

func _on_start_dash():
	print("start dash")
