extends Node2D

const SPEED = 60

var current_direction
var queued_direction
var feelers

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	feelers = {
		"up": $UpArea,
		"down": $DownArea,
		"left": $LeftArea,
		"right": $RightArea,
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if queued_direction && queued_direction != current_direction:
		print(feelers[queued_direction])
		if feelers[queued_direction].get_overlapping_bodies().is_empty():
			current_direction = queued_direction
	
	match current_direction:
		"up":
			if $UpArea.get_overlapping_bodies().is_empty():
				position.y -= SPEED * delta
		"down":
			if $DownArea.get_overlapping_bodies().is_empty():
				position.y += SPEED * delta
		"left":
			if $LeftArea.get_overlapping_bodies().is_empty():
				position.x -= SPEED * delta
		"right":
			if $RightArea.get_overlapping_bodies().is_empty():
				position.x += SPEED * delta
		_:
			pass

func _input(event):
	if event.is_action_pressed("move_up"):
		if $UpArea.get_overlapping_bodies().is_empty():
			current_direction = "up"
		else:
			queued_direction = "up"
	elif event.is_action_pressed("move_down"):
		if $DownArea.get_overlapping_bodies().is_empty():
			current_direction = "down"
		else:
			queued_direction = "down"
	elif event.is_action_pressed("move_left"):
		if $LeftArea.get_overlapping_bodies().is_empty():
			current_direction = "left"
		else:
			queued_direction = "left"
	elif event.is_action_pressed("move_right"):
		if $RightArea.get_overlapping_bodies().is_empty():
			current_direction = "right"
		else:
			queued_direction = "right"
