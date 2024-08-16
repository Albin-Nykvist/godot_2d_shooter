extends Node2D

var rotation_direction = 0

var rotation_speed = 0.08

func _ready():
	if randi() % 2 == 0:
		rotation_direction = 1
	else:
		rotation_direction = -1
	
	var random_rotation = fmod(randi(), 2.0 * PI)
	self.rotate(random_rotation)
	
	for child in get_children():
		child.rotation_speed = self.rotation_speed
		child.rotation_direction = -self.rotation_direction
		child.rotate(-random_rotation)

func _process(delta):
	self.rotate(rotation_speed * PI * delta * rotation_direction)
