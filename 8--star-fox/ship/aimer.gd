extends RigidBody3D

@export var speed: float

@onready var vertical_speed := speed * 0.85

func _physics_process(_delta):
	if Input.is_action_pressed("move_right"):
		linear_velocity.x += speed
	if Input.is_action_pressed("move_left"):
		linear_velocity.x -= speed
	if Input.is_action_pressed("move_up"):
		linear_velocity.y += vertical_speed
	if Input.is_action_pressed("move_down"):
		linear_velocity.y -= vertical_speed
