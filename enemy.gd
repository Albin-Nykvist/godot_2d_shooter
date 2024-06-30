extends CharacterBody2D
class_name Enemy

@export var max_health = 30.0
@export var health = 0.0 # set in the ready function
@export var speed = 50.0
@export var damage = 10.0
@export var direction = Vector2(0, 0)

@export var attack_target: Node = null

func _ready():
	health = max_health

func _physics_process(delta):
	if attack_target:
		if position.x < attack_target.position.x:
			direction.x = 1.0
		elif position.x > attack_target.position.x:
			direction.x = -1.0
		if position.y < attack_target.position.y:
			direction.y = 1.0
		elif position.y > attack_target.position.y:
			direction.y = -1.0
		velocity = direction.normalized() * speed
		move_and_collide(velocity * delta)


func _on_area_2d_body_entered(body):
	print("Enemy body entered")
	if body.is_in_group("projectiles"):
		print("im hit by projectile :()")
		recieve_damage(body.damage)
		self.position = self.position + body.direction.normalized() * 20.0
		body.destroy()
	elif body.is_in_group("players"):
		print("player hit by me :)")
		#self.position = self.position - self.direction * 10.0
		body.recieve_damage(self.damage)


func recieve_damage(damage: int):
	health -= damage
	if health <= 0:
		queue_free() # die
