extends Upgrade


var errupt_particles = preload("res://scenes/vfx_scenes/ParticleGroundHit.tscn")
var snow_scene = preload("res://scenes/hazard_scenes/snow.tscn")

var max_distance = 330
var min_distance = 80

var max_cool_down = 5.0
var min_cool_down = 0.1
var cool_down_counter = 0.0

func _ready():
	player.target_speed -= player.starting_speed * 0.05

func _process(delta):
	cool_down_counter -= delta
	if cool_down_counter <= 0.0:
		place_snow()
		cool_down_counter = min_cool_down + fmod(randi(), max_cool_down - min_cool_down)

func place_snow():
	var snow = snow_scene.instantiate()
	snow.position = player.position + Vector2(0, min_distance + fmod(randi(), max_distance - min_distance)).rotated(fmod(randi(), 2.0 * PI))
	player.get_parent().add_child(snow)
	
	var particles = errupt_particles.instantiate()
	particles.position = snow.position 
	particles.emitting = true
	player.get_parent().add_child(particles)


