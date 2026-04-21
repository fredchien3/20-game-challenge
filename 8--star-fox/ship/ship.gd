extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 0.5
@export var ProjectileScene: PackedScene

var brake_speed = speed * 1.5

var target_velocity = Vector3.ZERO
signal projectile_shot(projectile: RigidBody3D)

func _physics_process(_delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y += 1
	if Input.is_action_pressed("move_down"):
		direction.y -= 1

	target_velocity.x += direction.x * speed
	target_velocity.y += direction.y * speed
	
	if (
			not Input.is_action_pressed("move_right")\
			and not Input.is_action_pressed("move_left")\
			and not Input.is_action_pressed("move_up")\
			and not Input.is_action_pressed("move_down")
	):
		target_velocity = target_velocity.move_toward(Vector3.ZERO, brake_speed)

	velocity = target_velocity
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var projectile: RigidBody3D = ProjectileScene.instantiate()
		projectile.global_position = global_position
		projectile_shot.emit(projectile)
		
