extends RigidBody2D

signal exploded(pos, radius)

@export var TIME_DELAY: float
@export var EXPLOSION_RADIUS: float


func _ready() -> void:
	await get_tree().create_timer(TIME_DELAY).timeout
	exploded.emit(global_position, EXPLOSION_RADIUS)
	queue_free()
