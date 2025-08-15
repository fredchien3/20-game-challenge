extends CharacterBody2D

signal laser_on
signal laser_off
signal death

var alive = true

const THRUST = 75.0 * -1
const GRAVITY_MULTIPLIER = 2

func _process(delta: float) -> void:
	if alive and Input.is_action_pressed("ui_accept"):
		laser_on.emit()
		$Beam.visible = true
	else:
		laser_off.emit()
		$Beam.visible = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_MULTIPLIER

	if alive and Input.is_action_pressed("ui_accept"):
		velocity.y += THRUST

	move_and_slide()

func die() -> void:
	alive = false
	death.emit()
	$PlayerSprite.texture = load("res://scenes/player/shipPink_damage1.png")

func respawn() -> void:
	alive = true
	$PlayerSprite.texture = load("res://scenes/player/shipPink_manned.png")
