extends Node2D
class_name Spawner

## The scene that is instantiated by the spawner
@export var entity_scene: PackedScene

## Required to set the attack target of the enemy
@export var entity_is_enemy: bool
@export var entity_is_item: bool

## Spawners spawn things relative to the player
@export var player: Node

@export var min_spawn_distance_to_player: float
@export var max_spawn_distance_to_player: float

## The node where spawned entities are added as children
@export var spawn_node: Node = get_parent()

## The group to which spawned entities are added
@export var spawn_group: String

## Entities spawned by this spawner
@export var spawner_group: String

## Once every x seconds
@export var wave_rate: float = 5.0 
var wave_rate_counter: float = 0.0

@export var wave_size: int = 1

@export var symetric_wave = false
var spawn_angle = 0.0
var spawn_angle_increment = 0.0

## Number added to wave_size each time a wave is spawned
@export var wave_size_growth: int = 0

@export var spawn_wave_on_ready: bool = true

@export var max_number_of_entities: int = 100

@export var endless = true

## If not endless, the amount of units this spawner will spawn before being disabled
@export var num_spawns = 100
var spawn_counter = 0

func _ready():
	if spawn_wave_on_ready == false:
		wave_rate_counter = wave_rate
	spawn_node = self

func _process(delta):
	wave_rate_counter -= delta
	if wave_rate_counter < 0.0:
		spawn_wave()
		wave_rate_counter = wave_rate

func spawn_wave():
	var current_wave_size = wave_size
	var num_entities = 0
	for child in spawn_node.get_children():
		if child.is_in_group(spawner_group):
			num_entities += 1
	if num_entities + wave_size >= max_number_of_entities:
		current_wave_size = max_number_of_entities - num_entities 
	
	if symetric_wave and current_wave_size > 0:
		spawn_angle_increment =  (2.0 * PI) / current_wave_size 
	
	for i in range(0, current_wave_size):
		spawn_entity()
	wave_size += wave_size_growth

func spawn_entity():
	if endless == false and spawn_counter >= num_spawns: return
	spawn_counter += 1
	var entity = entity_scene.instantiate()
	entity.add_to_group(spawn_group)
	entity.add_to_group(spawner_group)
	spawn_node.add_child(entity)
	if entity_is_enemy:
		entity.attack_target = player
	elif entity_is_item:
		entity.set_to_falling()
	var unit_vector = Vector2.UP.rotated(randf() * 2 * PI)
	if symetric_wave:
		unit_vector = Vector2.UP.rotated(spawn_angle)
		spawn_angle += spawn_angle_increment
	var distance_to_player = min_spawn_distance_to_player + fmod(randi(), max_spawn_distance_to_player - min_spawn_distance_to_player + 1)
	entity.position = player.position + unit_vector.normalized() * distance_to_player 
