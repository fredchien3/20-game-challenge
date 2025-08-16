extends CharacterBody2D

func _process(_delta: float) -> void:
	var new_pos = position
	if Input.is_action_just_pressed("move_left"):
		new_pos.x -= 64
	elif Input.is_action_just_pressed("move_right"):
		new_pos.x += 64
	elif Input.is_action_just_pressed("move_up"):
		new_pos.y -= 64
	elif Input.is_action_just_pressed("move_down"):
		new_pos.y += 64

	var background = get_tree().get_first_node_in_group("background")
	if Utils.in_bounds(new_pos, background.get_rect().size):
		position = new_pos
