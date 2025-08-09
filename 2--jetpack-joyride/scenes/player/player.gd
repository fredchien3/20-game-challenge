extends CharacterBody2D


const SPEED = 300.0
const FLY_VELOCITY = -100.0
const GRAVITY_MULTIPLIER = 2.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_MULTIPLIER

	# Handle fly.
	if Input.is_action_pressed("ui_accept"):
		velocity.y += FLY_VELOCITY

	move_and_slide()
