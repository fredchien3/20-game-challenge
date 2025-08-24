extends Area2D

var alive = true

func _process(delta: float) -> void:
	if alive == false:
		return

	var new_pos = position

	if Input.is_action_just_pressed("move_left"):
		new_pos.x -= 64
	elif Input.is_action_just_pressed("move_right"):
		new_pos.x += 64
	elif Input.is_action_just_pressed("move_up"):
		new_pos.y -= 64
	elif Input.is_action_just_pressed("move_down"):
		new_pos.y += 64
	
	var following_log
	var in_river = false
	for area in get_overlapping_areas():
		if area.is_in_group("logs"):
			following_log = area
		if area.is_in_group("rivers"):
			in_river = true

	if following_log:
		new_pos.x += following_log.normalized_velocity
	elif in_river:
		drown()

	var background = get_tree().get_first_node_in_group("background")
	if Utils.in_bounds(new_pos, background.get_rect().size):
		position = new_pos

func die() -> void:
	if !alive:
		return

	print("Ribbit... I'm dead")
	alive = false
	$ColorRect.color = "red"
	$ColorRect/ColorRect2.color = "pink"
	z_index = 0

func drown():
	if !alive:
		return
		
	print("Glug glug glug")
	alive = false
	$ColorRect.color = "dark_blue"
	$ColorRect/ColorRect2.color = "light_blue"
	z_index = 0
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("cars"):
		die()
