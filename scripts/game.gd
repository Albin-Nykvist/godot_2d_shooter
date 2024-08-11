extends Node2D

@export var player: Node = null

var round_time = 300
var time = 3

func reset():
	get_tree().reload_current_scene()

func _process(delta):
	time -= delta
	player.time_label.text = "%02d:%02d" % [time/60, fmod(time, 60)]
	if time <= 0.0:
		level_cleared()
		time = round_time

func level_cleared():
	for child in self.get_children():
		if child.is_in_group("map") or child.is_in_group("enemy_team_spawner") or child.is_in_group("enemies"):
			
			# check if player has any node handles and remove them
			remove_child(child)
			child.queue_free()
	
	for child in player.get_children():
		if child.is_in_group("map_particle"):
			remove_child(child)
			child.queue_free()
	
	new_level()


func new_level():
	# add in a world scene
	# set player in middle
	player.position = Vector2.ZERO
	# add a level spawner (do not use the old spawner for this, but make a new one)
	pass
