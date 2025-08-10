extends CharacterBody2D

signal laser_on
signal laser_off

const SPEED = 300.0
const THRUST = -100.0
const GRAVITY_MULTIPLIER = 2.5

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		laser_on.emit()
		$Beam.visible = true
	else:
		laser_off.emit()
		$Beam.visible = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_MULTIPLIER

	# Handle fly.
	if Input.is_action_pressed("ui_accept"):
		velocity.y += THRUST
		
	#if Input.is_action_pressed("ui_right"):
		#velocity.x += 50
		#
	#if Input.is_action_pressed("ui_left"):
		#velocity.x -= 50

	move_and_slide()
