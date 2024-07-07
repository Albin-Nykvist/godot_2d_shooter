extends Control

@onready var card_container = $MarginContainer/HBoxContainer
@onready var container = $MarginContainer
var screen_size = DisplayServer.screen_get_size()
var screen_middle = Vector2(screen_size.x - (screen_size.x/2), screen_size.y - (screen_size.y/2))

var arrow_cursor = load("res://assets/cursor/cursor_arrow.png")
var previous_cursor = load("res://assets/cursor/cursor_point.png")

var upgrade_card_scene = preload("res://scenes/menu_scenes/ui_parts/upgrade_card.tscn")

var upgrades = [
	{
		title = "SPEED",
		description = "Increase speed by 10%",
		price = 10
	},
	{
		title = "DAMAGE",
		description = "Increase damage by 10%",
		price = 20
	}
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
		card_container.add_child(upgrade_card)

func remove_cards():
	for n in card_container.get_children():
		card_container.remove_child(n)
		n.queue_free()
