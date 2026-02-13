extends RigidBody2D

signal exploded(pos, radius)

@export var time_delay: float
@export var explosion_radius: float


func _ready() -> void:
	await get_tree().create_timer(time_delay).timeout
	exploded.emit(global_position, explosion_radius)
	queue_free()
