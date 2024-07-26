extends Enemy

var start_animation_speed = 0.0

func _ready():
	base_speed = 110.0
	speed_variation = 10.0
	speed_recovery = 3.5
	max_health = 120.0
	base_ready()
	start_animation_speed = character_sprite.speed_scale

func move(delta: float):
	velocity = direction.normalized() * speed


	if abs(direction.x - direction.y) < 0.05:
		character_sprite.speed_scale = start_animation_speed * 1.0
	elif abs(direction.x) > abs(direction.y):
		velocity = Vector2(velocity.x * 1.5, velocity.y * 0.5)
		character_sprite.speed_scale = start_animation_speed * 1.2
	else:
		velocity *= 0.6
		character_sprite.speed_scale = start_animation_speed * 0.8
	
	var velocity_before_collision = velocity
	var collision = move_and_collide(velocity * delta)
	move_around_collision(collision, velocity_before_collision, delta)
