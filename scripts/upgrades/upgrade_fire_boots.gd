extends Upgrade

var fire_scene = preload("res://scenes/hazard_scenes/fire.tscn")

var do_spawn_fire = false
var max_spawn_delay = 0.1
var spawn_delay_counter = 0.0
var rand_offset = 20

func _ready():
	player.fire_damage -= player.starting_fire_damage * 0.2
	player.begin_dash.connect(_on_begin_dash)

func _on_begin_dash():
	spawn_delay_counter = (randi() %  int(max_spawn_delay * 1000)) * 0.001
	do_spawn_fire = true

func _process(delta):
	if do_spawn_fire:
		spawn_delay_counter -= delta
		if spawn_delay_counter <= 0.0:
			do_spawn_fire = false
			spawn_fire()

func spawn_fire():
	var fire = fire_scene.instantiate()
	fire.life_time = 4.0
	fire.position = player.position + Vector2(-rand_offset + randi() % (rand_offset*2),-rand_offset + randi() % (rand_offset*2))
	player.get_parent().add_child(fire)
