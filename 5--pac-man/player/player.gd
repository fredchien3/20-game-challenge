extends Area2D

const SPEED = 90

var current_direction
var queued_direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_direction:
		"up":
			position.y -= SPEED * delta
		"down":
			position.y += SPEED * delta
		"left":
			position.x -= SPEED * delta
		"right":
			position.x += SPEED * delta
		_:
			pass

func _input(event):
	if event.is_action_pressed("move_up"):
		current_direction = "up"
	elif event.is_action_pressed("move_down"):
		current_direction = "down"
	elif event.is_action_pressed("move_left"):
		current_direction = "left"
	elif event.is_action_pressed("move_right"):
		current_direction = "right"
