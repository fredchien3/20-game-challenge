extends Area2D

signal request_respawn(frog)

signal death(frog)

const RESPAWN_TIMER = 1
var alive = true
var immunity_timer = 0

func _ready() -> void:
	z_index = 2

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
	
	var on_log = null
	var on_lilypad = null
	var in_river = false
	for area in get_overlapping_areas():
		if area.is_in_group("logs"):
			on_log = area
		if area.is_in_group("rivers"):
			in_river = true
		if area.is_in_group("lilypads"):
			on_lilypad = area

	if on_log:
		new_pos.x += on_log.normalized_velocity
	elif on_lilypad:
		pass
	elif in_river:
		if immunity_timer > 0:
			immunity_timer -= delta
		else:
			drown()

	var background = get_tree().get_first_node_in_group("background")
	if Utils.in_bounds(new_pos, background.get_rect().size):
		position = new_pos

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("cars"):
		die()

func die() -> void:
	if !alive: return
	print("Ribbit... I'm dead")
	alive = false
	$ColorRect.color = "red"
	$ColorRect/ColorRect2.color = "pink"
	z_index = 0
	death.emit(self)

func drown():
	if !alive: return
	print("Glug glug glug")
	alive = false
	$ColorRect.color = "dark_blue"
	$ColorRect/ColorRect2.color = "light_blue"
	z_index = 0
	death.emit(self)

func revive():
	immunity_timer = 0.1
	print("Hallelujer")
	alive = true
	$ColorRect.color = "dark_green"
	$ColorRect/ColorRect2.color = "light_green"
	z_index = 2
