extends StaticBody2D
class_name StaticProp

func _on_area_2d_body_entered(body):
	if body.is_in_group("projectiles"):
		body.destroy()
