extends CharacterBody2D
class_name Player

var item_scene = preload("res://scenes/item_scenes/urn.tscn")
#var projectile_scene = preload("res://scenes/projectile_scenes/projectile.tscn")

var cursor_point = preload("res://assets/cursor/cursor_point.png")
var cursor_circle = preload("res://assets/cursor/cursor_circle.png")

var dash_particles = preload("res://scenes/particle_scenes/ParticleDash.tscn")
var pick_up_particles = preload("res://scenes/particle_scenes/ParticlePickUp.tscn")

@onready var camera = $PlayerCamera
@onready var item_sprite = $HeldItemSprite
@onready var character_sprite = $CharacterSprite
@onready var health_bar = $Bar/Health
@onready var dash_bar = $Bar/Dash
@onready var time_label = $HeadsUpDisplay/TopBar/Time
@onready var coin_label = $HeadsUpDisplay/TopBar/Coins
@onready var collider = $CollisionShape2D

# time
var time = 0.0

# animate items sprite
const item_sprite_base_speed = 1.0
var item_sprite_speed = 1.0

# money
var coins = 0

# Dashing
var is_dashing = false
const dash_duration = 0.10
var dash_duration_counter = 0.0
const dash_speed = 1400.0
const dash_cool_down = 0.8
var dash_cool_down_counter = 0.0
var dash_direction = Vector2.ZERO

# Moving
var speed = 300.0
var direction = Vector2.ZERO

# Inventory
var reachable_items = []
var held_item: Node = null
var has_dropped_item = false

# Throwing
var throw_force = 1200.0
var is_throwing = false
var max_throw_time = 1.0 # makes sure we don't get stuck in the is_throwing state
var throw_time_counter = 0.0

# Health
var max_health = 100.0
var health = 0.0 # set in ready




func _ready():
	set_cursor()
	health = max_health
	item_sprite.hide()

func _physics_process(delta):
	if is_dashing:
		dash(delta)
	else:
		walk(delta)
		handle_dash_cool_down(delta)
	
	var velocity_before_collision = velocity
	var collision = move_and_collide(velocity * delta)
	move_around_collision(collision, velocity_before_collision, delta)

func move_around_collision(collision: KinematicCollision2D, velocity_before_collision: Vector2, delta: float):
	if collision == null: return
	
	var foregin_collider = collision.get_collider()
	if collider.is_in_group("map_edge"): 
		print("map_edge")
		return
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

func walk(delta: float):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction != Vector2.ZERO:
		self.direction = input_direction
	
	velocity = input_direction * self.speed
	look_towards_direction(input_direction)

func dash(delta: float):
	velocity = dash_direction * (self.dash_speed + self.speed)

	look_towards_direction(dash_direction)
	
	dash_duration_counter -= delta
	if dash_duration_counter <= 0.0:
		is_dashing = false
		dash_cool_down_counter = dash_cool_down

func handle_dash_cool_down(delta: float):
	if dash_cool_down_counter > 0.0:
		dash_cool_down_counter -= delta
		if dash_cool_down_counter < 0.0:
			dash_cool_down_counter = 0.0
		dash_bar.scale.x = 1.0 - (dash_cool_down_counter / dash_cool_down)
	if dash_cool_down_counter <= 0.0 and Input.is_action_pressed("dash"): # and Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO:
		is_dashing = true
		dash_direction = self.direction
		dash_duration_counter = dash_duration
		camera.shake_screen(0.1, 4.0)
		
		var particles = dash_particles.instantiate()
		particles.emitting = true
		particles.z_index = -1
		add_child(particles)

func look_towards_direction(direction: Vector2):
	if direction.x > 0.0:
		character_sprite.flip_h = true
	elif direction.x < 0.0:
		character_sprite.flip_h = false

func _process(delta):
	time += delta
	time_label.text = "%02d:%02d" % [time/60, fmod(time, 60)]
	
	if character_sprite.modulate != Color(1, 1, 1, 1):
		recover_colors()
	
	rotate_held_item()
	
	set_cursor()
	
	if throw_time_counter > 0 and is_throwing:
		throw_time_counter -= delta
	else:
		is_throwing = false

func rotate_held_item():
	var max_offset = 35.0
	if item_sprite.position.x < -max_offset:
		item_sprite_speed = item_sprite_base_speed
		item_sprite.z_index = 1
	elif item_sprite.position.x > max_offset:
		item_sprite_speed = -item_sprite_base_speed
		item_sprite.z_index = 0
	#item_sprite_speed *= 1.003
	var speed_modifier = 0.5
	item_sprite.position.x += item_sprite_speed * (1.0 + speed_modifier - (speed_modifier * abs(item_sprite.position.x / max_offset)))
	
	var base_scale = Vector2(1.0, 1.0)
	var scale_modifier = 0.08
	# Make sure the scales at max offset are the same in both 
	if item_sprite.z_index == 1:
		item_sprite.scale = base_scale * (1.0 + scale_modifier - (scale_modifier * abs(item_sprite.position.x / max_offset)))
	else:
		item_sprite.scale = base_scale * (1.0 - scale_modifier + (scale_modifier * abs(item_sprite.position.x / max_offset)))
	

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.is_echo() == false: 
		throw_item()
	
	if Input.is_action_just_pressed("drop"):
		if held_item == null:
			pick_up_item()
		else:
			drop_item()


func recover_colors(): # should depend on delta?
	var recovery_speed = 0.05
	if character_sprite.modulate.r < 1.0:
		character_sprite.modulate.r += recovery_speed
		if character_sprite.modulate.r > 1.0:
			character_sprite.modulate.r = 1.0
	if character_sprite.modulate.g < 1.0:
		character_sprite.modulate.g += recovery_speed
		if character_sprite.modulate.g > 1.0:
			character_sprite.modulate.g = 1.0
	if character_sprite.modulate.b < 1.0:
		character_sprite.modulate.b += recovery_speed
		if character_sprite.modulate.b > 1.0:
			character_sprite.modulate.b = 1.0

func pick_up_item():
	if has_dropped_item:
		has_dropped_item = false
		return

	if held_item == null and reachable_items.is_empty() == false:
		var item = reachable_items[0]
		reachable_items.erase(item)
		held_item = item
		item_sprite.texture = item.get_node("Sprite2D").texture
		item_sprite.show()
		item.get_parent().remove_child(item)
		item.monitorable = false # map edge removes items, so we have to make this one not monitorable
		item.monitoring = false
		add_child(item)
		item.position = Vector2.ZERO
		item.hide()
		var particles = pick_up_particles.instantiate()
		particles.emitting = true
		item_sprite.add_child(particles)

func throw_item():
	if held_item == null or is_throwing:
		return
	
	throw_time_counter = max_throw_time
	held_item.throw(self)

func drop_item(): # exploit: if you drop after fireing one sock, you still drop a sock item
	if held_item == null or is_throwing:
		return
	
	var item = held_item.duplicate()
	item.show()
	get_parent().add_child(item)
	item.position = self.position + Vector2(-10 + randi() % 21, -10)
	item.add_to_group("items")
	
	has_dropped_item = true
	remove_held_item()

func remove_held_item():
	remove_child(held_item)
	held_item = null
	item_sprite.hide()
	
	if reachable_items.is_empty() == false:
		pick_up_item()

func _on_pick_up_range_area_entered(area):
	if area.is_in_group("items"):
		reachable_items.append(area)
		if held_item == null:
			pick_up_item()
	elif area.is_in_group("coins"):
		self.coins += area.value
		coin_label.text = str(self.coins)
		area.destroy()

func _on_pick_up_range_area_exited(area):
	if area.is_in_group("items"):
		reachable_items.erase(area)

func recieve_damage(damage: int):
	health -= damage
	if health <= 0:
		print("Player died")
		get_parent().reset()
	
	camera.shake_screen(0.2, 18.0)
	
	health_bar.scale.x = health / max_health
	
	character_sprite.modulate = Color(1, 0, 0, 1)

func set_cursor():
	if held_item:
		DisplayServer.cursor_set_custom_image(cursor_circle, 0, Vector2(32, 32))
	else:
		DisplayServer.cursor_set_custom_image(cursor_point, 0, Vector2(32, 32))
