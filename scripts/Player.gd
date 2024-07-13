extends CharacterBody2D
class_name Player

var item_scene = preload("res://scenes/item_scenes/urn.tscn")
#var projectile_scene = preload("res://scenes/projectile_scenes/projectile.tscn")

var cursor_point = preload("res://assets/cursor/cursor_point.png")
var cursor_circle = preload("res://assets/cursor/cursor_circle.png")

var dash_particles = preload("res://scenes/vfx_scenes/ParticleDash.tscn")
var slide_particles = preload("res://scenes/vfx_scenes/ParticleSlide.tscn")
var pick_up_particles = preload("res://scenes/vfx_scenes/ParticlePickUp.tscn")

@onready var camera = $PlayerCamera
@onready var item_sprite = $HeldItemSprite
@onready var character_sprite = $CharacterSprite
@onready var health_bar = $Bar/Health
@onready var dash_bar = $Bar/Dash
@onready var time_label = $HeadsUpDisplay/TopBar/Time
@onready var coin_label = $HeadsUpDisplay/TopBar/Coins
@onready var collider = $CollisionShape2D
@onready var pickup_collider = $PickUpRange/CollisionShape2D

@onready var sfx_dash = $SfxDash
@onready var sfx_coin = $SfxCoin
@onready var sfx_hurt = $SfxHurt
@onready var sfx_throw = $SfxThrow

# time
var time = 0.0

# animate items sprite
const item_sprite_base_speed = 1.0
var item_sprite_speed = 1.0

# coins
var coins = 0

# Dashing
var is_dashing = false
var dash_duration = 0.10
var dash_duration_counter = 0.0
var dash_speed = 1400.0
var dash_cool_down = 0.8
var dash_cool_down_counter = 0.0
var dash_direction = Vector2.ZERO

# Teleporting
var teleport_cool_down = 2.0
var teleport_cool_down_counter = 0.0

# Sliding
var is_sliding = false
var slide_speed_bonus = 350.0
var current_slide_speed_bonus = 0.0
var slide_speed_reduction = 300.0
var slide_direction = Vector2.ZERO
var slide_cool_down = 0.15
var slide_cool_down_counter = 0.0

# Moving
var speed = 250.0
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

# Projectile
var proj_damage_mult = 1.0
var proj_stagger_mult = 1.0
var proj_knockback_mult = 1.0

# Health
var max_health = 100.0
var health = 0.0

# Invincibility period
var is_invincible = false
var invincible_duration = 0.2
var invincible_duration_counter = 0.0

# starting values (used by upgrades) (set during ready)
var starting_dash_duration
var starting_dash_cool_down
var starting_dash_speed
var starting_speed
var starting_pickup_radius_scale
var starting_throw_force
var starting_max_health
var starting_proj_damage_mult
var starging_proj_stagger_mult
var starting_proj_knockback_mult



# Signals: used for active upgrades
signal begin_dash
signal end_dash

signal begin_slide
signal end_slide

signal throw
signal projectile_created(projectile: Node)
signal pick_up
signal damage_recieved


func _ready():
	set_cursor()
	health = max_health
	item_sprite.hide()
	
	starting_dash_duration = dash_duration
	starting_dash_cool_down = dash_cool_down
	starting_dash_speed = dash_speed
	starting_speed = speed
	starting_pickup_radius_scale = pickup_collider.scale.x
	starting_throw_force = throw_force
	starting_max_health = max_health
	starting_proj_damage_mult = proj_damage_mult
	starging_proj_stagger_mult = proj_stagger_mult
	starting_proj_knockback_mult = proj_knockback_mult

func _physics_process(delta):
	if is_dashing:
		dash(delta)
	elif is_sliding:
		slide(delta)
	else:
		walk()
	

	var velocity_before_collision = velocity
	var collision = move_and_collide(velocity * delta)
	move_around_collision(collision, velocity_before_collision, delta)

func _process(delta):
	time += delta
	time_label.text = "%02d:%02d" % [time/60, fmod(time, 60)]
	
	if character_sprite.modulate != Color(1, 1, 1, 1):
		recover_colors()
	
	rotate_held_item()
	
	set_cursor()
	
	if !is_dashing:
		handle_dash_cool_down(delta)
	
	
	if throw_time_counter > 0 and is_throwing:
		throw_time_counter -= delta
	else:
		is_throwing = false
	
	if teleport_cool_down_counter > 0:
		teleport_cool_down_counter -= delta
	
	if is_sliding:
		character_sprite.scale.y = 0.95
		if character_sprite.flip_h:
			character_sprite.skew = -0.1 * PI
		else:
			character_sprite.skew = 0.1 * PI
		var particles = slide_particles.instantiate()
		particles.emitting = true
		particles.position = character_sprite.position + Vector2(0, 25)
		
		particles.z_index = -1
		add_child(particles)
	else:
		character_sprite.scale.y = 1.0
		character_sprite.skew = 0.0
	
	if slide_cool_down_counter > 0:
		slide_cool_down_counter -= delta
	
	if is_invincible:
		invincible_duration_counter -= delta
		if invincible_duration_counter <= 0:
			is_invincible = false

func _input(event):
	#if event is InputEventMouseButton and event.is_pressed() and event.is_echo() == false: 
	if Input.is_action_just_pressed("throw") and event is InputEventMouseButton and event.is_pressed() and event.is_echo() == false:
		throw_item()
	
	if Input.is_action_just_pressed("drop"):
		if held_item == null:
			pick_up_item()
		else:
			drop_item()
	
	if Input.is_action_just_pressed("teleport") and dash_cool_down_counter <= 0:
		position = get_global_mouse_position()
		dash_cool_down_counter = dash_cool_down * 1.5
		#teleport_cool_down_counter = teleport_cool_down
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_pressed("slide") and direction and slide_cool_down_counter <= 0 and !is_sliding:
		is_sliding = true
		slide_direction = direction
		current_slide_speed_bonus = slide_speed_bonus
	if (!Input.is_action_pressed("slide") and is_sliding) or (direction != slide_direction and is_sliding): 
		is_sliding = false
		slide_direction = Vector2.ZERO
		slide_cool_down_counter = slide_cool_down

func _on_pick_up_range_area_entered(area):
	if area.is_in_group("items"):
		reachable_items.append(area)
		if held_item == null:
			pick_up_item()
	elif area.is_in_group("coins"):
		self.coins += area.value
		update_coin_ui()
		area.destroy()
		play_sfx(sfx_coin)

func _on_pick_up_range_area_exited(area):
	if area.is_in_group("items"):
		reachable_items.erase(area)

func slide(delta):
	velocity = slide_direction * (self.current_slide_speed_bonus + self.speed)
	current_slide_speed_bonus -= slide_speed_reduction * delta
	if current_slide_speed_bonus < 0.0:
		current_slide_speed_bonus = 0
	look_towards_direction(slide_direction)

func move_around_collision(collision: KinematicCollision2D, velocity_before_collision: Vector2, delta: float):
	if collision == null: return
	
	var foregin_collider = collision.get_collider()
	if collider.is_in_group("map_edge"): 
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

func walk():
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
		end_dash.emit()


func handle_dash_cool_down(delta: float):
	if dash_cool_down_counter > 0.0:
		dash_cool_down_counter -= delta
		if dash_cool_down_counter < 0.0:
			dash_cool_down_counter = 0.0
		var bar_scale = 1.0 - (dash_cool_down_counter / dash_cool_down)
		if bar_scale < 0.0:
			bar_scale = 0.0
		dash_bar.scale.x = bar_scale
	if dash_cool_down_counter <= 0.0 and Input.is_action_pressed("dash"):
		play_sfx(sfx_dash)
		is_dashing = true
		if is_sliding:
			dash_direction = slide_direction
			current_slide_speed_bonus = slide_speed_bonus
		else:
			dash_direction = self.direction
		dash_duration_counter = dash_duration
		camera.shake_screen(0.1, 4.0)
		
		begin_dash.emit()
		
		var particles = dash_particles.instantiate()
		particles.emitting = true
		particles.z_index = -1
		add_child(particles)

func look_towards_direction(direction: Vector2):
	if direction.x > 0.0:
		character_sprite.flip_h = true
	elif direction.x < 0.0:
		character_sprite.flip_h = false


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
		pick_up_this_item(item)

func pick_up_this_item(item: Node):
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
	pick_up.emit()

func throw_item():
	if held_item == null or is_throwing:
		return
	
	throw_time_counter = max_throw_time
	held_item.throw(self)
	throw.emit()

func drop_item(): # exploit: if you drop after fireing one sock, you still drop a sock item
	if held_item == null or is_throwing:
		return
	
	
	var item = held_item.duplicate()
	item.show()
	get_parent().add_child(item)
	item.position = self.position + Vector2(-10 + randi() % 21, -10)
	item.add_to_group("items")
	item.monitorable = true 
	item.monitoring = true
	
	has_dropped_item = true
	remove_held_item()

func remove_held_item():
	remove_child(held_item)
	held_item = null
	item_sprite.hide()
	
	if reachable_items.is_empty() == false:
		pick_up_item()


func update_coin_ui():
	coin_label.text = str(self.coins)


func recieve_damage(damage: int):
	if is_invincible: return
	
	health -= damage
	is_invincible = true
	invincible_duration_counter = invincible_duration
	damage_recieved.emit()
	
	if health <= 0:
		get_parent().reset()
	
	camera.shake_screen(0.2, 18.0)
	
	health_bar.scale.x = health / max_health
	
	character_sprite.modulate = Color(1, 0, 0, 1)
	
	play_sfx(sfx_hurt)

func set_cursor():
	if held_item:
		DisplayServer.cursor_set_custom_image(cursor_circle, 0, Vector2(32, 32))
	else:
		DisplayServer.cursor_set_custom_image(cursor_point, 0, Vector2(32, 32))

func play_sfx(audio_node: Node):
	var original_pitch = audio_node.pitch_scale
	var variance = 0.3
	audio_node.pitch_scale = original_pitch - variance + randf() * variance
	audio_node.playing = true
	audio_node.pitch_scale = original_pitch
