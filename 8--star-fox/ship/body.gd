extends CharacterBody3D

@export var aimer: Node3D
@export var speed: float

var target_velocity := Vector3.ZERO

func _physics_process(_delta: float) -> void:
	look_at(aimer.global_position)
	velocity.x = (aimer.global_position.x - global_position.x) * speed
	velocity.y = (aimer.global_position.y - global_position.y) * speed
	move_and_slide()
