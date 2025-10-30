extends CharacterBody2D


const SPEED = 150.0

@onready var gravity_multiplier = 1.0

func get_modified_gravity():
	return get_gravity() * gravity_multiplier

func _physics_process(delta: float) -> void:
	velocity += get_modified_gravity() * delta

	if Input.is_action_just_pressed("ui_accept"):
		gravity_multiplier = -gravity_multiplier
		print(gravity_multiplier)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
