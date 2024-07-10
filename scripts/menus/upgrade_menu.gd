extends Control

@onready var card_container = $MarginContainer/HBoxContainer
@onready var container = $MarginContainer
var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

var arrow_cursor = load("res://assets/cursor/cursor_arrow.png")

var upgrade_card_scene = preload("res://scenes/menu_scenes/ui_parts/upgrade_card.tscn")

# Mechanics based upgrades can be nodes that we attach to the player
# They then listen for signals emitted by the player or something else
# For example: 
# 1. player emitts start_dashing
# 2. upgrade recieves signal
# 3. upgrade spawns fire for dash_duration

# Static upgrades simply change variables of the player
# This means we need to keep track of the players starting values (if we want non-exponential growth)
# We propably want to always use the starting values to increment or decrement with upgrades
# If we don't then the upgrades will be based on the current value, which makes the upgrade very inconsistent
# For example: 
#	- damage up 10% when we have 100 damage gives 110 damage
#	- damage up 10% when we have 200 damage gives 220 damage (twice as much increased)

@export var player: Node = null

# Upgrade scenes
var upgrade_speed = preload("res://scenes/upgrade_node_scenes/upgrade_speed.tscn")
var upgrade_damage = preload("res://scenes/upgrade_node_scenes/upgrade_damage.tscn")

var colors = [
	Color("#533747"),
	Color("#183A37"),
	Color("#A9714B"),
	Color("#88AB75"), 
	Color("#2D93AD"),
]

var upgrades = [
	{
		title = "SPEED",
		description = "Increase speed by 15%",
		price = 10,
		color = colors[4],
		upgrade_scene = upgrade_speed,
	},
	{
		title = "Damage",
		description = "Increase damage by 20%",
		price = 10,
		color = colors[1],
		upgrade_scene = upgrade_damage,
	},
]

var is_active = false

func _ready():
	# This garbage can not be centered by default, so this is centering for you 
	position = position - (screen_size/2.0)
	
	# Also, but more understandably center the container (there is probably a better way to do this)
	container.position = screen_middle - Vector2(container.size.x/2, container.size.y/2)

# DEV ONLY
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		toggle()
	if Input.is_action_just_pressed("pause"):
		if visible: # Going from upgrade_menu to pause_menu
			hide()

func _on_upgrade_timer_timeout():
	toggle()


func toggle():
	if visible:
		hide()
		get_tree().paused = false
		remove_cards()
		is_active = false
	else:
		get_tree().paused = true
		DisplayServer.cursor_set_custom_image(arrow_cursor)
		add_cards()
		show()
		is_active = true

func add_cards():
	for i in 4:
		var upgrade_card = upgrade_card_scene.instantiate()
		var upgrade = upgrades[randi() % upgrades.size()]
		upgrade_card.title = upgrade.title
		upgrade_card.description = upgrade.description
		
		if i == 0:
			upgrade_card.price = 0
		elif i == 1:
			upgrade_card.price = upgrade.price * 0.7
		elif i == 2:
			upgrade_card.price = upgrade.price
		else:
			upgrade_card.price = upgrade.price * 1.2
		
		upgrade_card.color = upgrade.color
		card_container.add_child(upgrade_card)
		upgrade_card.player = player
		upgrade_card.upgrade_scene = upgrade.upgrade_scene
		upgrade_card.upgrade_menu = self

func remove_cards():
	for n in card_container.get_children():
		card_container.remove_child(n)
		n.queue_free()


func _on_pause_menu_hidden():
	if is_active == true:
		get_tree().paused = true
		show()
