extends CharacterBody2D
class_name Player

var item_scene = preload("res://scenes/item.tscn")
var projectile_scene = preload("res://scenes/projectile.tscn")

var cursor_point = preload("res://assets/cursor_point.png")
var cursor_circle = preload("res://assets/cursor_circle.png")

@onready var hud = $HUD
@onready var item_sprite = $HeldItemSprite
@onready var character_sprite = $CharacterSprite

# animate items sprite
const item_sprite_base_speed = 1.0
var item_sprite_speed = 1.0

var money = 0

# Dashing
var is_dashing = false
const dash_duration = 0.15
var dash_duration_counter = 0.0
const dash_speed = 1200.0
const dash_cool_down = 0.5
var dash_cool_down_counter = 0.0
var dash_direction = Vector2(0, 0)

# Moving
var speed = 250.0

# Inventory
var reachable_items = []
var held_item = null
var has_dropped_item = false

# Throw force
var throw_force = 1200.0

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

func walk(delta: float):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * self.speed
	move_and_collide(velocity * delta)
	look_towards_direction(input_direction)

func dash(delta: float):
	velocity = dash_direction * (self.dash_speed + self.speed)
	move_and_collide(velocity * delta)
	look_towards_direction(dash_direction)
	
	dash_duration_counter -= delta
	if dash_duration_counter <= 0.0:
		is_dashing = false
		dash_cool_down_counter = dash_cool_down

func handle_dash_cool_down(delta: float):
	dash_cool_down_counter -= delta
	if dash_cool_down_counter <= 0.0:
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if Input.is_action_pressed("dash") and input_direction != Vector2(0, 0):
			is_dashing = true
			dash_direction = input_direction
			dash_duration_counter = dash_duration

func look_towards_direction(direction: Vector2):
	if direction.x > 0.0:
		character_sprite.flip_h = true
	elif direction.x < 0.0:
		character_sprite.flip_h = false

func _process(delta):
	if character_sprite.modulate != Color(1, 1, 1, 1):
		recover_colors()
	
	var max_offset = 35.0
	if item_sprite.position.x < -max_offset:
		item_sprite_speed = item_sprite_base_speed
		item_sprite.z_index = 1
	elif item_sprite.position.x > max_offset:
		item_sprite_speed = -item_sprite_base_speed
		item_sprite.z_index = -1
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
	
	set_cursor()


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
		print("Item picked up: ", held_item.name)

func throw_item():
	if held_item == null:
		return
	
	# Spawn a projectile
	print("Throwing")
	held_item = null
	item_sprite.hide()
	
	var throw = projectile_scene.instantiate()
	throw.position = self.position + item_sprite.position
	throw.add_to_group("projectiles")
	throw.look_at(get_global_mouse_position())
	throw.rotate(0.5 * PI) # Why this quarter rotation is necessary is beond me
	throw.direction = Vector2.UP.rotated(throw.rotation)
	throw.speed = throw_force
	get_parent().add_child(throw)

	if reachable_items.is_empty() == false:
		pick_up_item()

func drop_item():
	if held_item == null:
		return
	
	print("Dropping")
	held_item = null
	item_sprite.hide()
	
	var item = item_scene.instantiate()
	get_parent().add_child(item)
	item.position = self.position + Vector2(-10 + randi() % 21, -10)
	item.add_to_group("items")
	
	has_dropped_item = true

func _on_pick_up_range_area_entered(area):
	if area.is_in_group("items"):
		reachable_items.append(area)
		if held_item == null:
			pick_up_item()
	elif area.is_in_group("coins"):
		self.money += area.value
		var money_label = get_parent().get_node("PlayerMoney")
		money_label.text = str(self.money)
		area.get_parent().remove_child(area)

func _on_pick_up_range_area_exited(area):
	if area.is_in_group("items"):
		reachable_items.erase(area)

func recieve_damage(damage: int):
	health -= damage
	if health <= 0:
		print("Player died")
		get_parent().reset()
	
	var health_bar = get_node("HealthBar").get_child(0)
	health_bar.scale.x = health / max_health
	
	character_sprite.modulate = Color(1, 0, 0, 1)

func set_cursor():
	if held_item:
		DisplayServer.cursor_set_custom_image(cursor_circle)
	else:
		DisplayServer.cursor_set_custom_image(cursor_point)
