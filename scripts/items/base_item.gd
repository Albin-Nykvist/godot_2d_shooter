extends Area2D
class_name Item

var landing_particles = preload("res://scenes/vfx_scenes/ParticleGroundHit.tscn")

@export var projectile_scene = preload("res://scenes/projectile_scenes/projectile.tscn")

@onready var sprite = $Sprite2D
@onready var shadow = $Sprite2D/Shadow
@onready var collider = $CollisionShape2D

var is_falling = false
var fall_speed = 300
var fall_speed_variation = 200
var fall_acceleration = 1.05

var initial_offset = 1500
var initial_sprite_position: float
var initial_shadow_position: float

func _process(delta):
	base_process(delta)

func base_process(delta: float):
	if is_falling:
		fall_from_sky(delta)

func throw(player: Node):
	player.is_throwing = true
	var projectile = projectile_scene.instantiate()
	projectile.position = player.position #+ item_sprite.position
	projectile.add_to_group("projectiles")
	projectile.look_at(player.get_global_mouse_position())
	projectile.rotate(0.5 * PI) # Why this quarter rotation is necessary is beond me
	projectile.direction = Vector2.UP.rotated(projectile.rotation)
	projectile.speed = player.throw_force
	projectile.position += projectile.direction * 50 # nice initial offset
	player.get_parent().add_child(projectile)
	projectile.damage *= player.proj_damage_mult
	projectile.stagger *= player.proj_stagger_mult
	projectile.knockback *= player.proj_knockback_mult
	player.camera.shake_screen(0.05, 10.0)
	player.remove_held_item()
	player.is_throwing = false

func fall_from_sky(delta: float):
	sprite.position.y += fall_speed * delta
	shadow.position.y -= fall_speed * delta
	fall_speed *= fall_acceleration
	
	if sprite.position.y > initial_sprite_position:
		set_to_grounded()

func set_to_grounded():
	sprite.position.y = initial_sprite_position
	shadow.position.y = initial_shadow_position
	is_falling = false
	collider.disabled = false
	var particles = landing_particles.instantiate()
	add_child(particles)
	particles.position = Vector2(0, initial_shadow_position)
	particles.emitting = true

func set_to_falling():
	fall_speed += -fall_speed_variation + fmod(randi(), fall_speed_variation*2)
	initial_sprite_position = sprite.position.y
	initial_shadow_position = shadow.position.y
	collider.disabled = true
	sprite.position.y -= initial_offset
	shadow.position.y += initial_offset
	is_falling = true
