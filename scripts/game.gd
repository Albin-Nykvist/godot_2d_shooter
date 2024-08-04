extends Node2D

@export var player: Node = null

func reset():
	get_tree().reload_current_scene()

func level_cleared():
	var children = get_children()
	for child in children:
		if child != get_node("Player"):
			
			# check if player has any node handles and remove them
			remove_child(child)
			child.queue_free()
			
			new_level()


func new_level():
	# add in a world scene
	# set player in middle
	player.position = Vector2.ZERO
	# add a level spawner (do not use the old spawner for this, but make a new one)
	pass
