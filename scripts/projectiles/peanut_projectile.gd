extends Projectile

func _ready():
	damage = 60
	

func _process(delta):
	rotate(-0.06 * PI)
