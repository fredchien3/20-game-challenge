extends CharacterBody2D

signal grenade_thrown(grenade)
signal bazooka_shot(bazooka)
signal died(worm)
signal exploded(pos, radius)

# Movement
const SPEED := 150.0
const JUMP_VELOCITY := -300.0

@export var explosion_radius: float
# Aiming/charging
@export var power_rate: float
@export var max_power: float
# Weapon scenes
@export var GrenadeScene: PackedScene
@export var BazookaScene: PackedScene
@export var Active: Label
@export var Health: ProgressBar
@export var PowerBar: ProgressBar

## Whether it is this worm's turn to move and shoot
var active = false
var power := 0.0
var health := 100.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	handle_movement_input()
	handle_weapon_input(delta)

	move_and_slide()
	handle_labels()


# Event-based input handling
func _input(event: InputEvent) -> void:
	if not active:
		return

	if event is InputEventMouseButton and not event.is_pressed():
		# To find a vector pointing from A to B, use B - A.
		var a = global_position
		var b = get_global_mouse_position()
		var vector = (b - a).normalized() * power
		#throw_grenade(vector)
		shoot_bazooka(vector)
		power = 0


func handle_labels():
	if power > 0:
		PowerBar.value = (power / max_power) * 100
		var vec = (get_global_mouse_position() - global_position).normalized()
		PowerBar.rotation = vec.angle()
		PowerBar.visible = true
	else:
		PowerBar.visible = false

	if active:
		Active.visible = true
	else:
		Active.visible = false

	Health.value = health


func handle_movement_input() -> void:
	if active:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if active and direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.5)


func handle_weapon_input(delta: float) -> void:
	if not active:
		return

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


func receive_damage_and_knockback(explosion_pos: Vector2, radius: float):
	# TODO: Move these variables into the weapons
	var weapon_damage = 25
	var knockback_force = radius * 6
	health -= weapon_damage
	var knockback = (global_position - explosion_pos).normalized()
	velocity.x += knockback.x * knockback_force
	velocity.y += knockback.y * knockback_force

	if health <= 0:
		die_then_explode()


func die_then_explode():
	active = false
	died.emit(self)
	await get_tree().create_timer(2.5).timeout
	exploded.emit(global_position, explosion_radius)
	queue_free()
