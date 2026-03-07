extends CharacterBody2D

signal grenade_thrown(grenade)
signal bazooka_shot(bazooka)
signal died(bean)
signal exploded(pos, radius)

enum Type { PINTO, KIDNEY }

# Movement
const SPEED := 150.0
const JUMP_VELOCITY := -300.0
## How long the bean gets to move for after firing weapon
const MOVEMENT_ALLOWANCE_AFTER_FIRING := 1.0

@export var type: Type
@export var explosion_radius: float
# Aiming/charging variables
@export var power_rate: float
@export var max_power: float
# Weapon scenes/sprites
@export var GrenadeScene: PackedScene
@export var MissileScene: PackedScene
@export var weapon_sprite: Sprite2D
@export var grenade_texture: Resource
@export var bazooka_texture: Resource
# Main scenes
@export var health_bar: ProgressBar
@export var power_bar: ProgressBar
@export var body_sprite: AnimatedSprite2D
# Main sprites
@export var pinto_sprite_frames: SpriteFrames
@export var kidney_sprite_frames: SpriteFrames

var alive = true
var can_move = false
var can_shoot = false
var power := 0.0
var health := 20.0

@onready var current_weapon: PackedScene = GrenadeScene


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)

	if can_move:
		_handle_movement_input()

	if can_shoot:
		_handle_weapon_input(delta)

	_handle_labels()
	_handle_animations()

	move_and_slide()


# Event-based input handling
func _input(event: InputEvent) -> void:
	if not can_shoot:
		return

	if event is InputEventMouseButton and event.is_action_released("shoot"):
		# To find a vector pointing from A to B, use B - A.
		var a = global_position
		var b = get_global_mouse_position()
		var vector = (b - a).normalized() * power
		if current_weapon == GrenadeScene:
			throw_grenade(vector)
		elif current_weapon == MissileScene:
			shoot_bazooka(vector)
		else:
			printerr("Weapon not implemented")
		power = 0
		can_shoot = false

		await get_tree().create_timer(MOVEMENT_ALLOWANCE_AFTER_FIRING).timeout
		can_move = false

	if event.is_action_pressed("select_grenade"):
		weapon_sprite.texture = grenade_texture
		current_weapon = GrenadeScene
	elif event.is_action_pressed("select_bazooka"):
		weapon_sprite.texture = bazooka_texture
		current_weapon = MissileScene


func set_type(_type: Type) -> void:
	type = _type
	if type == Type.KIDNEY:
		body_sprite.sprite_frames = kidney_sprite_frames


## Controls whether it's this bean's turn
func set_active(status: bool):
	can_move = status
	can_shoot = status


## Instantiates a grenade with the correct position and velocity, emits it
## for parent to handle
func throw_grenade(vector: Vector2):
	var grenade = GrenadeScene.instantiate()
	grenade.position = position
	grenade.apply_impulse(vector)
	grenade_thrown.emit(grenade)


func shoot_bazooka(vector: Vector2):
	var bazooka = MissileScene.instantiate()
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
	alive = false
	set_active(false)
	died.emit(self)
	body_sprite.animation = "dead"
	await get_tree().create_timer(2.5).timeout
	exploded.emit(global_position, explosion_radius)
	queue_free()


func die_from_oob():
	set_active(false)
	died.emit(self)
	queue_free()


func _handle_weapon_input(delta: float) -> void:
	# Charge up weapon power
	if Input.is_action_pressed("shoot"):
		if power < max_power:
			power += power_rate * delta


func _handle_labels():
	if can_move and can_shoot and power > 0:
		power_bar.value = (power / max_power) * 100
		var vec = (get_global_mouse_position() - global_position).normalized()
		power_bar.rotation = vec.angle()
		power_bar.visible = true

		weapon_sprite.rotation = vec.angle()
		weapon_sprite.flip_h = false
		weapon_sprite.flip_v = vec.angle_to(Vector2.UP) > 0
	else:
		power_bar.visible = false

	if can_shoot:
		weapon_sprite.visible = true
	else:
		weapon_sprite.visible = false

	health_bar.value = health


func _handle_movement_input() -> void:
	# TODO: add static typing

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		body_sprite.flip_h = direction < 0
		weapon_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.5)


func _handle_animations() -> void:
	if not alive:
		if velocity.y != 0:
			body_sprite.animation = "dead_midair"
		else:
			body_sprite.animation = "dead"
		return
	if velocity.y != 0:
		body_sprite.animation = "jump"
		return
	if velocity.x != 0:
		body_sprite.animation = "walk"
		return

	body_sprite.animation = "idle"
	return
