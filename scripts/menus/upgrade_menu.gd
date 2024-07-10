extends Control

@onready var card_container = $MarginContainer/HBoxContainer
@onready var container = $MarginContainer
var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

var arrow_cursor = load("res://assets/cursor/cursor_arrow.png")
var previous_cursor = load("res://assets/cursor/cursor_point.png")

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

var start_dash_test = preload("res://scenes/upgrade_node_scenes/start_dash_test.tscn")

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
		description = "Increase speed by 10%",
		price = 10,
		color = colors[4],
		id = 0,
		upgrade_scene = start_dash_test,
	},
	{
		title = "DAMAGE",
		description = "Increase damage by 10%",
		price = 20,
		color = colors[2],
		id = 1,
		upgrade_scene = start_dash_test,
	},
		{
		title = "DASH",
		description = "Increase dash speed by 20%",
		price = 22,
		color = colors[1],
		id = 2,
		upgrade_scene = start_dash_test,
	},
	{
		title = "DROP RATE",
		description = "Items drop in 5% faster",
		price = 19,
		color = colors[0],
		id = 3,
		upgrade_scene = start_dash_test,
	},
	{
		title = "KNOCKBACK",
		description = "Increase knockback by 5%",
		price = 41,
		color = colors[3],
		id = 4,
		upgrade_scene = start_dash_test,
	},
]

func _ready():
	# This garbage can not be centered by default, so this is centering for you 
	position = position - (screen_size/2.0)
	
	# Also, but more understandably center the container (there is probably a better way to do this)
	container.position = screen_middle - Vector2(container.size.x/2, container.size.y/2)

# DEV ONLY
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		toggle()

func _on_upgrade_timer_timeout():
	toggle()


func toggle():
	if visible:
		DisplayServer.cursor_set_custom_image(previous_cursor)
		hide()
		get_tree().paused = false
		remove_cards()
	else:
		get_tree().paused = true
		DisplayServer.cursor_set_custom_image(arrow_cursor)
		add_cards()
		show()

func add_cards():
	for i in 3:
		var upgrade_card = upgrade_card_scene.instantiate()
		var upgrade = upgrades[randi() % upgrades.size()]
		upgrade_card.title = upgrade.title
		upgrade_card.description = upgrade.description
		upgrade_card.price = upgrade.price
		upgrade_card.color = upgrade.color
		card_container.add_child(upgrade_card)
		upgrade_card.player = player
		upgrade_card.upgrade_scene = upgrade.upgrade_scene
		print(upgrade_card.upgrade_scene)

func remove_cards():
	for n in card_container.get_children():
		card_container.remove_child(n)
		n.queue_free()

func _on_upgrade_card_pressed(upgrade_id):
	print("upgrade ", upgrade_id)
