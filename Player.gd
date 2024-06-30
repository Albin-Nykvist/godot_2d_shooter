extends CharacterBody2D
class_name Player

var item_scene = preload("res://item.tscn")
var projectile_scene = preload("res://projectile.tscn")

@onready var item_sprite = $HeldItemSprite
@onready var character_sprite = $CharacterSprite

var speed = 300.0

var reachable_items = []
var held_item = null

var throw_force = 1200.0


var max_health = 100.0
var health = 0.0 # set in ready




func _ready():
	health = max_health
	item_sprite.hide()

func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	if input_direction.x > 0.0:
		character_sprite.flip_h = true
	elif input_direction.x < 0.0:
		character_sprite.flip_h = false
	
	move_and_collide(velocity * delta)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.is_echo() == false: 
		# When adding a camera to player this will not be correct
		# mouse position will not be updated when moving camera 
		# leading to wrong mouse coordinates when throwing/shooting 
		# in this way.
		throw_item(event.position)

func pick_up_item(item):
	if item and held_item == null:
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
		pick_up_item(reachable_items[0])
		reachable_items.remove_at(0)

func _on_pick_up_range_area_entered(area):
	if area.is_in_group("items"):
		if held_item == null:
			pick_up_item(area)
		else:
			reachable_items.append(area)

func _on_pick_up_range_area_exited(area):
	if area.is_in_group("items"):
		reachable_items.erase(area)

func recieve_damage(damage: int):
	health -= damage
	if health <= 0:
		print("Player died")
		get_parent().reset()
