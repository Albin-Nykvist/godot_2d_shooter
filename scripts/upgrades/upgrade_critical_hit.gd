extends Upgrade


func _ready():
	player.projectile_created.connect(_on_projectile_created)

func _on_projectile_created(projectile: Node):
	if randi() % 100 < 20:
		projectile.damage *= 2
