extends Enemy


var start_fly_speed = 50
var fly_speed = 800
var fly_speed_variance = 50
var fly_acceleration = 1.2
var landing_deacceleration = 0.9
var fly_time = 1.2
var fly_time_counter = 0.0
var fly_delay = 3.0
var fly_delay_counter = 0.0
var is_flying = false

func _ready():
	fly_delay_counter = fmod(randi(), fly_delay)
	fly_speed += -fly_speed_variance + randi() % (fly_speed_variance*2)
	
	max_health = 200.0
	
	base_ready()

func _process(delta):
	if is_flying:
		if fly_time_counter > fly_delay * 0.1:
			speed *= fly_acceleration
			if speed > fly_speed:
				speed = fly_speed
		else:
			speed *= landing_deacceleration
		fly_time_counter -= delta
		if fly_time_counter <= 0.0:
			set_idle()
	else:
		fly_delay_counter -= delta
		if fly_delay_counter <= 0.0:
			set_flying()
	base_process(delta)

func set_idle():
	is_flying = false
	speed = 0.0
	start_speed = 0.0
	fly_delay_counter = fly_delay
	collider.disabled = false
	z_index = 0
	character_sprite.play("default")

func set_flying():
	speed = fly_speed
	start_speed = fly_speed
	is_flying = true
	fly_time_counter = fly_time
	collider.disabled = true
	z_index = 1
	character_sprite.play("fly")

func recieve_damage_after():
	set_idle()
