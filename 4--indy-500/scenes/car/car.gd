extends RigidBody2D

var acceleration = 500
var roll_friction = 500
#var max_velocity = 300
var steer_direction
var steer_speed = 5
var angular_velocity_limit = 2.5

#func _draw():
	#var fred = Vector2(1, 0) * velocity
	#var left = Vector2(0, -1) * 100
	#var right = Vector2(0, 1) * 100
	#draw_line(Vector2(0,0), fred, "white", 2.0)
	#draw_line(Vector2(0,0), left, "red", 2.0)
	#draw_line(Vector2(0,0), right, "blue", 2.0)
#
#func _process(_delta):
	#queue_redraw()

#func _physics_process(delta: float) -> void:
	#if Input.is_action_pressed("accelerate_forward") or \
	   #Input.is_action_pressed("accelerate_backward"):
		#steer_direction = Input.get_axis("steer_left", "steer_right")
		#rotation += steer_direction * steer_speed * delta
		#velocity += transform.x * Input.get_axis("accelerate_backward", "accelerate_forward") * acceleration * delta
	#var left = Vector2(0, -1)
	#var right = Vector2(0, 1)
	##else:
		##velocity.x = move_toward(velocity.x, 0, roll_friction)
		##velocity.y = move_toward(velocity.y, 0, roll_friction)
#
	#move_and_slide()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity := state.get_linear_velocity()
	var step := state.get_step()

	# Get inputs
	var accelerating := Input.is_action_pressed("accelerate_forward")
	var decelerating := Input.is_action_pressed("accelerate_backward")
	var steering_left := Input.is_action_pressed("steer_left")
	var steering_right := Input.is_action_pressed("steer_right")
	
	# Handle gas or reverse
	if accelerating or decelerating:
		velocity += transform.x * Input.get_axis("accelerate_backward", "accelerate_forward") * acceleration * step
		if steering_left or steering_right:
			steer_direction = Input.get_axis("steer_left", "steer_right")
			if angular_velocity > -angular_velocity_limit and angular_velocity < angular_velocity_limit:
				angular_velocity += steer_direction * steer_speed * step

	# Correct course if not already steering
	if !steering_left && !steering_right:
		angular_velocity = move_toward(angular_velocity, 0, steer_speed * step)

	# Roll to stop
	if not accelerating and not decelerating and velocity != Vector2(0, 0):
		velocity.x = move_toward(velocity.x, 0, roll_friction * step)
		velocity.y = move_toward(velocity.y, 0, roll_friction * step)

	state.set_linear_velocity(velocity)

	
