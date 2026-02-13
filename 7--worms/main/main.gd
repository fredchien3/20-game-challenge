extends Node2D

@export var terrain: StaticBody2D
@export var camera: Camera2D

var active_worm: CharacterBody2D
var active_worm_index := 0
var worms: Array[Node]


func _ready() -> void:
	worms = get_tree().get_nodes_in_group("worms")
	worms.sort_custom(left_to_right)

	active_worm = worms[active_worm_index]
	active_worm.active = true
	camera.global_position = active_worm.global_position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_p"):
		cycle_active_worm()


func cycle_active_worm():
	active_worm.active = false
	active_worm_index += 1

	if active_worm_index >= len(worms):
		active_worm_index = 0

	active_worm = worms[active_worm_index]
	active_worm.active = true
	camera.global_position = active_worm.global_position


func left_to_right(a, b):
	if a.global_position < b.global_position:
		return true
