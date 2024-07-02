extends CharacterBody2D
class_name Player

var item_scene = preload("res://item.tscn")
var projectile_scene = preload("res://projectile.tscn")

@onready var item_sprite = $HeldItemSprite
@onready var character_sprite = $CharacterSprite

# Dashing
var is_dashing = false
const dash_duration = 0.15
var dash_duration_counter = 0.0
const dash_speed = 1200.0
const dash_cool_down = 0.4
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
	health = max_health
	item_sprite.hide()

func _physics_process(delta):
	if is_dashing:
		dash(delta)
	else:
		walk(delta)
		handle_dash_cool_down(delta)
	
	var margin = 20.0
	var screen_size = DisplayServer.screen_get_size()
	if position.x < margin:
		position.x = margin
	elif position.x > screen_size.x - margin:
		position.x = screen_size.x -  margin
	if position.y < margin:
		position.y = margin
	elif position.y > screen_size.y - margin:
		position.y = screen_size.y - margin

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

func _process(_delta):
	if character_sprite.modulate != Color(1, 1, 1, 1):
		recover_colors()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.is_echo() == false: 
		throw_item(event.position)
	
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

func throw_item(towards_position):
	if held_item == null:
		return
	
	# Spawn a projectile
	print("Throwing")
	held_item = null
	item_sprite.hide()
	
	var throw = projectile_scene.instantiate()
	get_parent().add_child(throw)
	throw.position = self.position
	throw.add_to_group("projectiles")
	throw.direction = Vector2(towards_position.x - position.x, towards_position.y - position.y).normalized()
	throw.speed = throw_force
	
	# if we are standing on an item, we should pick it up right after throwing
	# solution with a lot of overhead: use a list of 'reachable' items
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
	item.position = self.position
	item.add_to_group("items")
	
	has_dropped_item = true

func _on_pick_up_range_area_entered(area):
	if area.is_in_group("items"):
		reachable_items.append(area)
		if held_item == null:
			pick_up_item()

func _on_pick_up_range_area_exited(area):
	if area.is_in_group("items"):
		reachable_items.erase(area)

func recieve_damage(damage: int):
	health -= damage
	if health <= 0:
		print("Player died")
		get_parent().reset()
	
	character_sprite.modulate = Color(1, 0, 0, 1)
