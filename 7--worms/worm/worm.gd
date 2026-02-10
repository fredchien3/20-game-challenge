extends CharacterBody2D

signal grenade_thrown(grenade)

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

@export var GrenadeScene: PackedScene


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


# To find a vector pointing from A to B, use B - A.
func _input(event):
	if event.is_action_pressed("shoot"):
		var b = event.position
		var a = position
		var vector = b - a
		throw_grenade(vector)


func throw_grenade(vector: Vector2):
	var grenade = GrenadeScene.instantiate()
	grenade.position = position
	grenade.apply_impulse(vector)
	grenade_thrown.emit(grenade)
