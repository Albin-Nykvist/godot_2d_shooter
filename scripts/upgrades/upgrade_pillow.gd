extends Upgrade

var enemy: Node = null

var damage = 5
var knockback = 900

var delay = 0.05
var delay_counter = 0.0

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies") and player.is_sliding:
		delay_counter = delay
		enemy = body

func _process(delta):
	if delay_counter > 0.0:
		delay_counter -= delta
		if delay_counter <= 0.0:
			apply()

func apply():
	if enemy != null:
		enemy.recieve_damage(damage)
		var angle_variance = 0.25 * PI
		var direction = player.slide_direction.rotated(-angle_variance + fmod(randi(), angle_variance*2))
		enemy.set_knock_back(knockback, direction)
