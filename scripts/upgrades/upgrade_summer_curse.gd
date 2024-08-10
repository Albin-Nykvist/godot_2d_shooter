extends Upgrade


var errupt_particles = preload("res://scenes/vfx_scenes/ParticleGroundHit.tscn")
var fire_scene = preload("res://scenes/hazard_scenes/fire.tscn")

var max_distance = 330
var min_distance = 180

var max_cool_down = 6.0
var min_cool_down = 0.1
var cool_down_counter = 0.0

func _ready():
	player.max_health -= 10.0
	if player.max_health <= 0.0:
		player.max_health = 1.0
	if player.health > player.max_health:
		player.health = player.max_health
	
	player.update_health_ui()

func _process(delta):
	cool_down_counter -= delta
	if cool_down_counter <= 0.0:
		place_fire()
		cool_down_counter = min_cool_down + fmod(randi(), max_cool_down - min_cool_down)

func place_fire():
	var fire = fire_scene.instantiate()
	fire.position = player.position + Vector2(0, min_distance + fmod(randi(), max_distance - min_distance)).rotated(fmod(randi(), 2.0 * PI))
	player.get_parent().add_child(fire)
	
	var particles = errupt_particles.instantiate()
	particles.position = fire.position 
	particles.emitting = true
	player.get_parent().add_child(particles)
