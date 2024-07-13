extends Upgrade

var damage_mult = 1.5
var speed_mult = 1.6

func _ready():
	player.projectile_created.connect(_on_projectile_created)

func _on_projectile_created(projectile: Node):
	if projectile != null and player.is_sliding:
		projectile.damage *= damage_mult
		projectile.speed *= speed_mult
