extends Upgrade

var damage = 25

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies") and player.is_dashing:
		body.recieve_damage(damage)
