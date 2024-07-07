extends MarginContainer
class_name UpgradeCard

@export var title: String = "no name found"
@export var description: String = "no description found"
@export var price: int = -1

@onready var title_label = $MarginContainer/VBoxContainer/Label
@onready var description_text_box = $MarginContainer/VBoxContainer/RichTextLabel
@onready var button = $MarginContainer/VBoxContainer/MarginContainer/Button

func _ready():
	update()

func update():
	title_label.text = title
	description_text_box.text = description
	button.text = str(price)
