extends CharacterBody2D
class_name Enemy

@export var max_health = 100.0
@export var health = 0.0 # set in the ready function
@export var speed = 0.0
@export var base_speed = 50.0
@export var start_speed = 0.0
@export var speed_recovery = 0.5
@export var damage = 10.0
@export var direction = Vector2(0, 0)

@export var attack_target: Node = null

@onready var character_sprite = $CharacterSprite
@onready var shadow = $CharacterSprite/Shadow

var is_dead = false
var death_duration = 0.3
var death_duration_counter = 0.0

func _ready():
	health = max_health
	character_sprite.speed_scale = 1.0 + ((-2 + randi() % 5) * 0.1)
	start_speed = base_speed + (-10 + randi() % 21) # 21 because 0 is also an option
	speed = start_speed

func _physics_process(delta):
	if is_dead: return
	if attack_target: # and randi() % 100 < 1: makes enemies appear dumb (good?)
		direction = attack_target.position - position
		var margin = 50.0
		if direction.x > 0:
			character_sprite.flip_h = true
		elif direction.x < 0:
			character_sprite.flip_h = false
		velocity = direction.normalized() * speed
		move_and_collide(velocity * delta)

func _process(delta):
	if character_sprite.modulate.r > 1.0:
		character_sprite.modulate.r -= 10.0
		if character_sprite.modulate.r < 1.0:
			character_sprite.modulate.r = 1.0
	if character_sprite.modulate.g > 1.0:
		character_sprite.modulate.g -= 10.0
		if character_sprite.modulate.g < 1.0:
			character_sprite.modulate.g = 1.0
	if character_sprite.modulate.b > 1.0:
		character_sprite.modulate.b -= 10.0
		if character_sprite.modulate.b < 1.0:
			character_sprite.modulate.b = 1.0
	
	if is_dead:
		death_duration_counter += delta
		if character_sprite.rotation < 0.5 * PI: 
			var rotation_speed = 0.020 * PI
			if character_sprite.flip_h == true:
				rotation_speed = -rotation_speed
			character_sprite.rotate(rotation_speed) 
		if death_duration_counter >= death_duration:
			queue_free()
	
	if speed < start_speed:
		speed += speed_recovery
		if speed > start_speed:
			speed = start_speed

func _on_area_2d_body_entered(body):
	if is_dead: return
	print("Enemy body entered")
	if body.is_in_group("projectiles"):
		print("im hit by projectile :()")
		recieve_damage(body.damage)
		self.position = self.position + body.direction.normalized() * 20.0 # knockback
		character_sprite.modulate = Color(100, 100, 100,1) # White flash
		body.destroy()
	elif body.is_in_group("players"):
		print("player hit by me :)")
		#self.position = self.position - self.direction * 10.0
		if not body.is_dashing:
			body.recieve_damage(self.damage)


func recieve_damage(damage: int):
	if is_dead: return
	health -= damage
	if health <= 0:
		is_dead = true
		character_sprite.pause()
		shadow.hide()
		#queue_free() # die
	
	speed = speed - (damage/2.0)
	if speed < 0.0:
		speed = 0.0
