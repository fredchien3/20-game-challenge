extends RigidBody2D

var acceleration = 600
var roll_friction = 200

var steer_speed = 20
var steer_limit = 2.5

var sideways_friction = 1.5

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
			var steer_direction = Input.get_axis("steer_left", "steer_right")
			if angular_velocity > -steer_limit and angular_velocity < steer_limit:
				angular_velocity += steer_direction * steer_speed * step

	# Correct course if not already steering
	if !steering_left && !steering_right:
		angular_velocity = move_toward(angular_velocity, 0, steer_speed * step)
		
	# Handle lateral friction
	var sideways_velocity = transform.y.dot(linear_velocity)
	var sideways_force = -transform.y * sideways_velocity * sideways_friction * step
	velocity.x += sideways_force.x
	velocity.y += sideways_force.y

	# Roll to stop
	if not accelerating and not decelerating and velocity != Vector2(0, 0):
		velocity.x = move_toward(velocity.x, 0, roll_friction * step)
		velocity.y = move_toward(velocity.y, 0, roll_friction * step)

	state.set_linear_velocity(velocity)

	
