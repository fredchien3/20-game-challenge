extends RigidBody2D

signal explode(pos, radius)
const TIME_DELAY = 1.0
const EXPLOSION_RADIUS = 50

func _ready() -> void:
	await get_tree().create_timer(TIME_DELAY).timeout
	explode.emit(global_position, EXPLOSION_RADIUS)
	queue_free()
