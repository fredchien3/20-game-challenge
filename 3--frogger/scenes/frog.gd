extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _process(delta: float) -> void:
	var new_pos = position
	if Input.is_action_just_pressed("move_left"):
		new_pos.x -= 64
	elif Input.is_action_just_pressed("move_right"):
		new_pos.x += 64
	elif Input.is_action_just_pressed("move_up"):
		new_pos.y -= 64
	elif Input.is_action_just_pressed("move_down"):
		new_pos.y += 64
		
	if in_bounds(new_pos):
		position = new_pos

func in_bounds(new_pos) -> bool:
	if new_pos.x < 0 or new_pos.y < 0:
		return false
		
	var map_size = get_parent().size
	if new_pos.x >= map_size[0] or new_pos.y >= map_size[1]:
		return false
		
	return true
