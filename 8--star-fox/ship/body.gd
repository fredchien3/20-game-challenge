extends CharacterBody3D

@export var aimer: Node3D
@export var speed: float

var target_velocity := Vector3.ZERO

func _physics_process(_delta: float) -> void:
	look_at(aimer.global_position)
	target_velocity = Vector3(aimer.global_position.x, aimer.global_position.y, 0) - global_position
	velocity = target_velocity * speed
	move_and_slide()
