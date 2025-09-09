extends RigidBody2D

@export var player_num: int

const ACCELERATION = 800
const ROLL_FRICTION = 200

const STEER_SPEED = 20
const STEER_LIMIT = 2.5

const SIDEWAYS_FRICTION = 1
const DRIFTING_FRICTION = 3

var accelerate_action
var decelerate_action
var steer_left_action
var steer_right_action
var drift_action

var previous_steer_direction

func _ready() -> void:
	if player_num == 2:
		$Body.texture = load("res://scenes/car/car_green.png")
	accelerate_action = "accelerate_forward_" + str(player_num)
	decelerate_action = "accelerate_backward_" + str(player_num)
	steer_left_action = "steer_left_" + str(player_num)
	steer_right_action = "steer_right_" + str(player_num)
	drift_action = "drift_" + str(player_num)

func _process(_delta: float) -> void:
	$Wheels/LeftWheel.rotation_degrees = angular_velocity * 12
	$Wheels/RightWheel.rotation_degrees = angular_velocity * 12

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity := state.get_linear_velocity()
	var step := state.get_step()

	# Get inputs
	var accelerating := Input.is_action_pressed(accelerate_action)
	var decelerating := Input.is_action_pressed(decelerate_action)
	var steer_direction := Input.get_axis(steer_left_action, steer_right_action)
	var drifting := Input.is_action_pressed(drift_action)
	
	# Handle drift
	var sideways_friction
	if drifting:
		sideways_friction = DRIFTING_FRICTION
	else:
		sideways_friction = SIDEWAYS_FRICTION

	# Handle gas or reverse
	if accelerating or decelerating:
		if not drifting:
			velocity += transform.x \
				* Input.get_axis(decelerate_action, accelerate_action) \
				* ACCELERATION * step
		if steer_direction != 0:
			if (previous_steer_direction != steer_direction) \
			or (angular_velocity > -STEER_LIMIT and angular_velocity < STEER_LIMIT):
				previous_steer_direction = steer_direction
				angular_velocity += steer_direction * STEER_SPEED * step

	# Correct course if not already steering
	if steer_direction == 0:
		angular_velocity = move_toward(angular_velocity, 0, STEER_SPEED * step)

	# Handle lateral friction
	var sideways_velocity = transform.y.dot(linear_velocity)
	var sideways_force = -transform.y * sideways_velocity * sideways_friction * step
	velocity.x += sideways_force.x
	velocity.y += sideways_force.y

	# Roll to stop
	if not accelerating and not decelerating and velocity != Vector2(0, 0):
		velocity.x = move_toward(velocity.x, 0, ROLL_FRICTION * step)
		velocity.y = move_toward(velocity.y, 0, ROLL_FRICTION * step)

	state.set_linear_velocity(velocity)
