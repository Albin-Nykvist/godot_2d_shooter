extends MarginContainer
class_name UpgradeCard

@export var upgrade_menu: Node = null

@export var player: Node = null

## The scene we attach to the player
@export var upgrade_scene: PackedScene = null

@export var title: String = "no name found"
@export var description: String = "no description found"
@export var price: int = -1
@export var color: Color = Color(0.0, 0.0, 0.0)
@export var is_item: bool = false

@onready var title_label = $MarginContainer/VBoxContainer/Label
@onready var description_text_box = $MarginContainer/VBoxContainer/RichTextLabel
@onready var button = $MarginContainer/VBoxContainer/MarginContainer/Button
@onready var panel = $Panel

func _ready():
	update()

func update():
	title_label.text = title
	description_text_box.text = description
	button.text = str(price)
	
	# This took way to long to figure out
	var styleBox: StyleBoxFlat = panel.get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", color)
	panel.add_theme_stylebox_override("panel", styleBox)


func _on_button_pressed():
	var cost = int(button.text)
	
	player.coins -= cost
	player.update_coin_ui()
	
	var upgrade = upgrade_scene.instantiate()
	if is_item: assign_item(upgrade)
	upgrade.player = player
	player.add_child(upgrade)
	
	upgrade_menu.toggle()

var coffee_item = preload("res://scenes/item_scenes/coffee.tscn")
var socks_item = preload("res://scenes/item_scenes/socks.tscn")
var fish_item = preload("res://scenes/item_scenes/fish.tscn")
var corn_item = preload("res://scenes/item_scenes/corn.tscn")
var lamp_item = preload("res://scenes/item_scenes/lamp.tscn")
var snowball_item = preload("res://scenes/item_scenes/snowball.tscn")

func assign_item(upgrade: Node):
	if title == "COFFEE":
		upgrade.item_scene = coffee_item
	elif title == "SOCKS":
		upgrade.item_scene = socks_item
	elif title == "FISH":
		upgrade.item_scene = fish_item
	elif title == "CORN":
		upgrade.item_scene = corn_item
	elif title == "LAMP":
		upgrade.item_scene = lamp_item
	elif title == "SNOWBALL":
		upgrade.item_scene = snowball_item
