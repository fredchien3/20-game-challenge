extends RigidBody3D

@export var speed: Vector3

func _ready() -> void:
	linear_velocity = speed
