extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		position.x -= 64
	elif Input.is_action_just_pressed("move_right"):
		position.x += 64
	elif Input.is_action_just_pressed("move_up"):
		position.y -= 64
	elif Input.is_action_just_pressed("move_down"):
		position.y += 64
