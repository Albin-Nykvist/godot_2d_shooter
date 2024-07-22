extends Projectile


var pop_time = 0.178
var is_popped = false

@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D

var popped_texture = preload("res://assets/projectile_sprites/popped_corn.png")

var rotation_direction = 1.0

var angle_variance = 0.10 * PI

func _ready():
	damage = 0.0
	knockback = 0.0
	stagger = 1.0
	life_time = 5.0
	speed = speed * 1.2
	if randi() % 2 == 0:
		rotation_direction = -1.0

func _process(delta):
	if is_popped:
		rotate(rotation_direction * -0.2 * PI)

func _physics_process(delta):
	velocity = direction * speed

	time += delta
	if time > life_time:
		destroy()
	
	if !is_popped and time > pop_time:
		pop()
	
	move_and_collide(velocity * delta)

func pop():
	is_popped = true
	damage = 50.0
	stagger = 0.4
	knockback = 300.0
	collider.scale *= 1.68
	speed *= 0.45
	sprite.texture = popped_texture
	rotate(-angle_variance + fmod(randi(), angle_variance*2))
	direction = Vector2.UP.rotated(self.rotation)
