extends MarginContainer
class_name UpgradeCard

# Attach game, so that we can enact changes
@export var game: Node = null

@export var title: String = "no name found"
@export var description: String = "no description found"
@export var price: int = -1
@export var color: Color = Color(0.0, 0.0, 0.0)

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
