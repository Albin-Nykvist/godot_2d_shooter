extends Enemy

@onready var particle_dig = preload("res://scenes/vfx_scenes/ParticleDig.tscn")

var life_time = 30.0
var life_time_variation = 1.0
var time = 0.0

var is_dissapearing = false
var dissapear_time = 1.0
var dissapear_time_counter = 0.0

func _ready():
	base_speed = 60.0
	speed_variation = 0.1
	speed_recovery = 3.5
	max_health = 300.0
	life_time += -life_time_variation + fmod(randi(), life_time_variation*2)

	base_ready()
	
	self.scale = Vector2(0.8, 0.4)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 1.0).set_trans(Tween.TRANS_SPRING)


func _process(delta):
	base_process(delta)
	
	if time <= 0.0:
		add_dig_particle()
	
	time += delta
	if time >= life_time and !is_dissapearing:
		is_dissapearing = true
		dissapear_time_counter = dissapear_time
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(0.7, 0.4), 1.0).set_trans(Tween.TRANS_SPRING)
		add_dig_particle()
	
	
	if is_dissapearing:
		
		dissapear_time_counter -= delta
		if dissapear_time_counter <= 0.0:
			queue_free()

func add_dig_particle():
	var dig = particle_dig.instantiate()
	dig.position = self.position + Vector2(0, 40)
	get_parent().add_child(dig)
	dig.emitting = true
