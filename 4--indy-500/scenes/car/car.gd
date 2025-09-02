extends CharacterBody2D

var speed = 15
var rotation_direction = 0
var rotation_speed = 4

func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("accelerate_forward")\
	or Input.is_action_pressed("accelerate_backward"):
		rotation_direction = Input.get_axis("steer_left", "steer_right")	
		rotation += rotation_direction * rotation_speed * delta

		velocity += transform.x * Input.get_axis("accelerate_backward", "accelerate_forward") * speed

	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)


	#var direction := Input.get_axis("accelerate_forward", "accelerate_backward")
	#if direction:
		#velocity.x = direction * SPEED
	#else:

	move_and_slide()
