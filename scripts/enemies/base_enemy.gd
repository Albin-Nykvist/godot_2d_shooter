extends CharacterBody2D
class_name Enemy

## Money drop scene
@export var coin_scene = preload("res://scenes/money_drop.tscn")

## Max health
@export var max_health = 100.0
var health = 0.0 # set in the ready function

## Base speed
@export var base_speed = 50.0

## Randomly changes base_speed on _ready, max=base_speed+speed_variation, min=base_speed-speed_variation
@export var speed_variation = 10.0
var speed = 0.0
var start_speed = 0.0

## Knockback
var is_knocked_back = false
var knockback_direction = Vector2.ZERO
var knockback_speed = 0.0
const knockback_duration = 0.1
var knockback_duration_counter = 0.0

## How fast the enemy recovers speed (time from 0 speed to base speed)
@export var speed_recovery = 0.5

var direction = Vector2(0, 0)

## Damage done to player
@export var damage = 10.0

## How fast is damage applied to player
@export var damage_rate = 0.8
var damage_rate_counter = 0.0

## Attack target
@export var attack_target: Node = null
var reachable_target: Node = null # used to check if attack target is in reach

@onready var character_sprite = $CharacterSprite
@onready var shadow = $CharacterSprite/Shadow
@onready var collider = $CollisionShape2D

var is_dead = false
var death_duration = 0.3
var death_duration_counter = 0.0

func _ready():
	base_ready()

func _physics_process(delta):
	base_physics_process(delta)

func _on_area_2d_body_entered(body):
	base_body_entered(body)

func _on_area_2d_body_exited(body):
	base_body_exited(body)

func _process(delta):
	base_process(delta)





func base_body_entered(body):
	if is_dead: return
	if body.is_in_group("projectiles"):
		recieve_damage(body.damage)
		speed *= body.stagger
		
		# Knockback
		is_knocked_back = true
		knockback_speed = body.knockback
		knockback_direction = body.direction.normalized()
		knockback_duration_counter = knockback_duration
		# Apply an instant knockback
		self.position += knockback_direction * (knockback_speed * 0.1)
		
		character_sprite.modulate = Color(100, 100, 100,1) # White flash
		body.destroy()
	elif body.is_in_group("players"):
		reachable_target = body
		damage_rate_counter = 0.1

func base_body_exited(body):
	if body == reachable_target:
		reachable_target = null

func base_process(delta: float):
	reset_color()
	
	if is_dead:
		handle_death(delta)
	
	if speed < start_speed:
		recover_speed(delta)
	
	if is_knocked_back:
		if knockback_duration_counter > 0.0:
			knockback_duration_counter -= delta
		else:
			is_knocked_back = false
	
	if reachable_target and reachable_target.is_dashing == false:
		damage_rate_counter -= delta
		if damage_rate_counter <= 0.0:
			deal_damage(reachable_target)

func base_ready():
	health = max_health
	
	# Randomize animation speed (looks better when you have many enemies in game)
	character_sprite.speed_scale = 1.0 + ((-2 + randi() % 5) * 0.1)
	
	# Assign start speed (the speed this creature will try to move at)
	start_speed = base_speed + (-speed_variation + fmod(randi(), speed_variation*2))
	speed = start_speed

func base_physics_process(delta: float):
	# Knockback even if dead, because it looks cool
	if is_knocked_back:
		velocity = knockback_direction * knockback_speed
		move_and_collide(velocity * delta)
	
	if is_dead: return

	if attack_target: # and randi() % 100 < 1: makes enemies appear dumb (good?)
		move_towards_target(delta)




func move_towards_target(delta: float):
	direction = attack_target.position - position
	flip_sprite(direction.x)
	velocity = direction.normalized() * speed
	var velocity_before_collision = velocity
	var collision = move_and_collide(velocity * delta)
	move_around_collision(collision, velocity_before_collision, delta)

# Flips sprite depending on if direction is positive or negative
func flip_sprite(direction: float):
	if direction > 0:
		character_sprite.flip_h = true
	elif direction < 0:
		character_sprite.flip_h = false

func handle_death(delta: float):
	death_duration_counter += delta
	if character_sprite.rotation < 0.5 * PI: 
		var rotation_speed = 0.020 * PI
		if character_sprite.flip_h == true:
			rotation_speed = -rotation_speed
		character_sprite.rotate(rotation_speed) 
	if death_duration_counter >= death_duration:
		queue_free()

func move_around_collision(collision: KinematicCollision2D, velocity_before_collision: Vector2, delta: float):
	if collision == null:
		return
	
	var foregin_collider = collision.get_collider()
	var my_collider_position = self.position - self.collider.position
	
	var rotation = 0.5 * PI
	if abs(velocity_before_collision.x) > abs(velocity_before_collision.y):
		velocity_before_collision.y = 0.0
		if velocity_before_collision.x > 0.0:
			if my_collider_position.y < foregin_collider.position.y:
				rotation = -rotation
		else:
			if my_collider_position.y > foregin_collider.position.y:
				rotation = -rotation
	else:
		velocity_before_collision.x = 0.0 # might not be necessary
		if velocity_before_collision.y > 0.0:
			if my_collider_position.x > foregin_collider.position.x:
				rotation = -rotation
		else:
			if my_collider_position.x < foregin_collider.position.x:
				rotation = -rotation
	
	velocity = velocity_before_collision.rotated(rotation)
	move_and_collide(velocity * delta)

func reset_color():
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

func deal_damage(target: Node):
	reachable_target.recieve_damage(self.damage)
	damage_rate_counter = damage_rate

func recover_speed(delta: float):
	# this should really be done before and after moving
	# but this approximation is fine
	speed += (start_speed / speed_recovery) * delta
	if speed > start_speed:
		speed = start_speed

func recieve_damage(damage: int):
	if is_dead: return
	health -= damage
	if health <= 0:
		var coin = coin_scene.instantiate()
		coin.position = self.position + Vector2(-10 + randi() % 21, -10)
		get_parent().add_child(coin)
		is_dead = true
		character_sprite.pause()
		shadow.hide()


