extends MeshInstance3D

@export var speed: float

@onready var vertical_speed := speed * 0.85

func _physics_process(_delta):
	print(vertical_speed)
	if Input.is_action_pressed("move_right"):
		global_position.x += speed
	if Input.is_action_pressed("move_left"):
		global_position.x -= speed
	if Input.is_action_pressed("move_up"):
		global_position.y += vertical_speed
	if Input.is_action_pressed("move_down"):
		global_position.y -= vertical_speed
