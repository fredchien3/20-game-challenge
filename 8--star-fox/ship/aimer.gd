extends MeshInstance3D

func _physics_process(_delta):
	if Input.is_action_pressed("move_right"):
		global_position.x += 0.1
	if Input.is_action_pressed("move_left"):
		global_position.x -= 0.1
	if Input.is_action_pressed("move_up"):
		global_position.y += 0.1
	if Input.is_action_pressed("move_down"):
		global_position.y -= 0.1
