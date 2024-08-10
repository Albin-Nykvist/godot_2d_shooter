extends Upgrade

var coin_scene = preload("res://scenes/money_drop.tscn")

var max_distance = 400
var min_distance = 0

var cool_down = 8.0
var cool_down_counter = 0.0

func _ready():
	pass

func _process(delta):
	cool_down_counter -= delta
	if cool_down_counter <= 0.0:
		place_coin()
		cool_down_counter = cool_down

func place_coin():
	var coin = coin_scene.instantiate()
	coin.position = self.position + Vector2(min_distance + fmod(randi(), max_distance - min_distance), 0).rotated(fmod(randi(), 2.0 * PI))
	get_parent().get_parent().add_child(coin)
	coin.set_to_falling()
	coin.set_idle()
