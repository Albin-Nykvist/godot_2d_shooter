extends MarginContainer
class_name UpgradeCard

# Allows us to interact with the upgrade menu (for example close it after pressing button)
#@export var upgrade_menu: Node = null

##@export var game: Node = null
@export var player: Node = null

## The scene we attach to the player
@export var upgrade_scene: PackedScene = null

@export var title: String = "no name found"
@export var description: String = "no description found"
@export var price: int = -1
@export var color: Color = Color(0.0, 0.0, 0.0)
@export var id: int = -1

@onready var title_label = $MarginContainer/VBoxContainer/Label
@onready var description_text_box = $MarginContainer/VBoxContainer/RichTextLabel
@onready var button = $MarginContainer/VBoxContainer/MarginContainer/Button
@onready var panel = $Panel

func _ready():
	update()

func _input(event):
	if Input.is_action_just_pressed("pause"):
		if visible:
			hide()
		else:
			show()

func update():
	title_label.text = title
	description_text_box.text = description
	button.text = str(price)
	
	# This took way to long to figure out
	var styleBox: StyleBoxFlat = panel.get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", color)
	panel.add_theme_stylebox_override("panel", styleBox)


func _on_button_pressed():
	var upgrade = upgrade_scene.instantiate()
	upgrade.player = player
	player.add_child(upgrade)
