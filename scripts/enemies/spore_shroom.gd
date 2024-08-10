extends Enemy

@onready var spore_scene = preload("res://scenes/hazard_scenes/spore.tscn")

const spores_to_place = 9
var spores_placed = 0
const spore_place_delay = 1.7
var spore_place_delay_counter = 0.0
var is_placing_spores = false

var spore_place_cool_down = 50.0
var spore_place_cool_down_counter = 0.0

func _ready():
	base_speed = 90.0
	speed_variation = 12.0
	speed_recovery = 4.0
	max_health = 250.0
	set_idle()
	spore_place_cool_down_counter = randi() % int(spore_place_cool_down)
	base_ready()

func _process(delta):
	if is_placing_spores:
		spore_place_delay_counter -= delta
		if spore_place_delay_counter <= 0.0:
			place_spore()
			spore_place_delay_counter = spore_place_delay
			spores_placed += 1
			if spores_placed >= spores_to_place:
				set_idle()
	else:
		spore_place_cool_down_counter -= delta
		if spore_place_cool_down_counter <= 0.0:
			set_place_spores()
	
	base_process(delta)

func place_spore():
	var spore_cloud = spore_scene.instantiate()
	spore_cloud.position = self.position
	spore_cloud.life_time = 20
	get_parent().add_child(spore_cloud)

func set_place_spores():
	spore_place_delay_counter = spore_place_delay
	spores_placed = 0
	is_placing_spores = true

func set_idle():
	is_placing_spores = false
	spore_place_cool_down_counter = spore_place_cool_down
