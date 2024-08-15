extends StaticBody2D

@onready var particles = $Particles

@onready var collider = $CollisionShape2D

var poison_duration = 12.0

var life_time = 0.4

func _ready():
	particles.emitting = true

func _process(delta):
	life_time -= delta
	if life_time <= 0.0:
		queue_free()
