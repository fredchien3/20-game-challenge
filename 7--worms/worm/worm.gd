extends CharacterBody2D

signal grenade_thrown(grenade)
signal bazooka_shot(bazooka)

# Movement
const SPEED := 150.0
const JUMP_VELOCITY := -300.0

# Aiming/charging
@export var power_rate: float
@export var max_power: float
# Weapon scenes
@export var GrenadeScene: PackedScene
@export var BazookaScene: PackedScene

## Whether it is this worm's turn to move and shoot
var active = false

@onready var power := 0.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if active:
		handle_movement_input()
		handle_weapon_input(delta)

	move_and_slide()
	handle_debug()


# Event-based input handling
func _input(event: InputEvent) -> void:
	if not active:
		return

	if event is InputEventMouseButton and not event.is_pressed():
		# To find a vector pointing from A to B, use B - A.
		var a = position
		var b = event.position
		var vector = (b - a).normalized() * power
		#throw_grenade(vector)
		shoot_bazooka(vector)
		power = 0


func handle_debug():
	# debug
	if power > 0:
		$DebugPower.text = str(int(power))

	if active:
		$DebugActive.visible = true
	else:
		$DebugActive.visible = false


func handle_movement_input() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func handle_weapon_input(delta: float) -> void:
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


func shoot_bazooka(vector: Vector2):
	var bazooka = BazookaScene.instantiate()
	bazooka.shooter = self
	bazooka.rotation = vector.angle()
	bazooka.position = position
	bazooka.apply_impulse(vector)
	bazooka_shot.emit(bazooka)
