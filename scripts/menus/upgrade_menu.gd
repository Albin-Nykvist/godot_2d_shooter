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
var upgrade_lance = preload("res://scenes/upgrade_node_scenes/upgrade_lance.tscn")
var upgrade_pillow = preload("res://scenes/upgrade_node_scenes/upgrade_pillow.tscn")
var upgrade_momentum = preload("res://scenes/upgrade_node_scenes/upgrade_momentum.tscn")
var upgrade_laundry = preload("res://scenes/upgrade_node_scenes/upgrade_backwards_sock.tscn")
var upgrade_item = preload("res://scenes/upgrade_node_scenes/upgrade_item.tscn")
var upgrade_endurance = preload("res://scenes/upgrade_node_scenes/upgrade_endurance.tscn")

var colors = [
	Color("#533747"),
	Color("#183A37"),
	Color("#A9714B"),
	Color("#88AB75"), 
	Color("#2D93AD"),
]

var upgrades = [
	{
		title = "FAST FEET",
		description = "Increase speed by 15%",
		price = 10,
		color = colors[0],
		upgrade_scene = upgrade_speed,
		is_item = false,
	},
	{
		title = "LETHALITY",
		description = "Increase projectile damage by 35%",
		price = 10,
		color = colors[0],
		upgrade_scene = upgrade_damage,
		is_item = false,
	},
	{
		title = "CHARGE",
		description = "Deals 25 damage to enemies you dash through",
		price = 10,
		color = colors[0],
		upgrade_scene = upgrade_lance,
		is_item = false,
	},
	{
		title = "ENDURANCE",
		description = "Reduce dash cool down by 10% and increase dash length by 10%",
		price = 10,
		color = colors[0],
		upgrade_scene = upgrade_endurance,
		is_item = false,
	},
	#{
		#title = "SUMMER CURSE",
		#description = "Sometimes lights the ground on fire around you and decrease max health by 10%",
		#price = 10,
		#color = colors[0],
		#upgrade_scene = upgrade_lance,
		#is_item = false,
	#},
	#{
		#title = "WINTER CURSE",
		#description = "Sometimes creates piles of snow around you and decrease speed by 10%",
		#price = 10,
		#color = colors[0],
		#upgrade_scene = upgrade_lance,
		#is_item = false,
	#},
	
	
	# Slide related
	#{
		#title = "PILLOW",
		#description = "Deals 5 damage and knocks back enemies you slide into",
		#price = 10,
		#color = colors[0],
		#upgrade_scene = upgrade_pillow,
		#is_item = false,
	#},
	#{
		#title = "MOMENTUM",
		#description = "+50% damage and +20% speed on projectiles thrown while sliding",
		#price = 10,
		#color = colors[0],
		#upgrade_scene = upgrade_momentum,
		#is_item = false,
	#},
	{
		title = "LAUNDRY LOB",
		description = "50% chance of throwing a sock when dashing",
		price = 10,
		color = colors[0],
		upgrade_scene = upgrade_laundry,
		is_item = false,
	},
]

var items = [
	{
		title = "SOCKS",
		description = "(ITEM) Throws 2 projectiles in quick succession",
		price = 10,
		color = colors[1],
		upgrade_scene = upgrade_item,
		is_item = true,
	},
	{
		title = "COFFEE",
		description = "(ITEM) Good for close range",
		price = 10,
		color = colors[1],
		upgrade_scene = upgrade_item,
		is_item = true,
	},
	{
		title = "FISH",
		description = "(ITEM) It's a big fish",
		price = 10,
		color = colors[1],
		upgrade_scene = upgrade_item,
		is_item = true,
	},
	{
		title = "CORN",
		description = "(ITEM) Corn is useless, but it turns into popcorn!",
		price = 10,
		color = colors[1],
		upgrade_scene = upgrade_item,
		is_item = true,
	},
	{
		title = "LAMP",
		description = "(ITEM) Bursts into fire on impact!",
		price = 10,
		color = colors[1],
		upgrade_scene = upgrade_item,
		is_item = true,
	},
	{
		title = "SNOWBALL",
		description = "(ITEM) Covers the ground with snow on impact.",
		price = 10,
		color = colors[1],
		upgrade_scene = upgrade_item,
		is_item = true,
	},
]

var is_active = false

func _ready():
	position = position - (screen_size/2.0)
	container.position = screen_middle - Vector2(container.size.x/2, container.size.y/2)

# DEV ONLY
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		toggle()
	if Input.is_action_just_pressed("pause"):
		if visible: # Going from upgrade_menu to pause_menu
			hide()

func _on_pause_menu_hidden():
	if is_active == true:
		get_tree().paused = true
		show()

func _on_player_coin_picked_up():
	if player.coins >= player.next_upgrade_coin_amount:
		toggle()
		player.next_upgrade_coin_amount = 1 + floori(player.next_upgrade_coin_amount * 1.2)
		player.update_coin_ui()

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
	for i in 5:
		var upgrade_card = upgrade_card_scene.instantiate()
		var upgrade = upgrades[randi() % upgrades.size()]
		if i < 2:
			upgrade = items[randi() % items.size()]
		upgrade_card.title = upgrade.title
		upgrade_card.description = upgrade.description
		
		if i == 0:
			upgrade_card.price = floori(player.next_upgrade_coin_amount * 0.7)
		elif i == 1:
			upgrade_card.price = floori(player.next_upgrade_coin_amount * 1.0)
		elif i == 2:
			upgrade_card.price = floori(player.next_upgrade_coin_amount * 0.7)
		elif i == 3:
			upgrade_card.price = floori(player.next_upgrade_coin_amount * 0.85)
		else:
			upgrade_card.price = floori(player.next_upgrade_coin_amount * 1.0)
		
		upgrade_card.color = upgrade.color
		upgrade_card.is_item = upgrade.is_item
		card_container.add_child(upgrade_card)
		upgrade_card.player = player
		upgrade_card.upgrade_scene = upgrade.upgrade_scene
		upgrade_card.upgrade_menu = self

func remove_cards():
	for n in card_container.get_children():
		card_container.remove_child(n)
		n.queue_free()

