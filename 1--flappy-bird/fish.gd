extends CharacterBody2D

signal death

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
	
	move_and_slide()

func on_collision():
	print("ouch!")
	death.emit()
	queue_free()

func gain_point():
	print("point get")
