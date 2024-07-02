extends Control

var time = 0.0

@onready var time_label = $TopBar/Time
@onready var coins_label = $TopBar/Coins


func _process(delta):
	time += delta
	time_label.text = str(round(time))
