extends CharacterBody2D

signal grenade_thrown(grenade)

# Movement
const SPEED := 150.0
const JUMP_VELOCITY := -250.0

# Aiming/charging
@export var power_rate: float
@export var max_power: float
# Weapon scenes
@export var GrenadeScene: PackedScene

@onready var power := 0.0


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_input(delta)

	# debug
	if power > 0:
		$DebugLabel.text = str(int(power))


# Event-based input handling
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		# To find a vector pointing from A to B, use B - A.
		var a = position
		var b = event.position
		var vector = (b - a).normalized() * power
		throw_grenade(vector)
		power = 0


func handle_movement(delta: float) -> void:
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


# Polling-based input handling
func handle_input(delta: float) -> void:
	# Charge up weapon power
	if Input.is_action_pressed("shoot"):
		if power < max_power:
			power += power_rate * delta


## Instantiates a grenade with the correct position and velocity, emits it
## for parent to handle
func throw_grenade(vector: Vector2):
	var grenade = GrenadeScene.instantiate()
	grenade.position = position
	grenade.apply_impulse(vector)
	grenade_thrown.emit(grenade)
