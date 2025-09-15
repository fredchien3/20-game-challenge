extends Node2D

const SPEED = 90
const TILE_SIZE = 16

@onready var current_direction = null
@onready var queued_direction = null
@onready var feelers = {
	"up": $UpArea,
	"down": $DownArea,
	"left": $LeftArea,
	"right": $RightArea,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if queued_direction && queued_direction != current_direction:
		if feelers[queued_direction].get_overlapping_bodies().is_empty():
			current_direction = queued_direction
	
	match current_direction:
		"up":
			if $UpArea.get_overlapping_bodies().is_empty():
				position.y -= SPEED * delta
			else:
				snap_to_grid()
		"down":
			if $DownArea.get_overlapping_bodies().is_empty():
				position.y += SPEED * delta
			else:
				snap_to_grid()
		"left":
			if $LeftArea.get_overlapping_bodies().is_empty():
				position.x -= SPEED * delta
			else:
				snap_to_grid()
		"right":
			if $RightArea.get_overlapping_bodies().is_empty():
				position.x += SPEED * delta
			else:
				snap_to_grid()
		_:
			pass
			
	for body in $BodyArea.get_overlapping_bodies():
		if body.is_in_group("walls"):
			print('collision')
			snap_to_grid()

func _input(event):
	if event.is_action_pressed("move_up"):
		if $UpArea.get_overlapping_bodies().is_empty():
			current_direction = "up"
			queued_direction = null
		else:
			queued_direction = "up"
	elif event.is_action_pressed("move_down"):
		if $DownArea.get_overlapping_bodies().is_empty():
			current_direction = "down"
			queued_direction = null
		else:
			queued_direction = "down"
	elif event.is_action_pressed("move_left"):
		if $LeftArea.get_overlapping_bodies().is_empty():
			current_direction = "left"
			queued_direction = null
		else:
			queued_direction = "left"
	elif event.is_action_pressed("move_right"):
		if $RightArea.get_overlapping_bodies().is_empty():
			current_direction = "right"
			queued_direction = null
		else:
			queued_direction = "right"

func snap_to_grid():
	position.x = snapped(position.x, TILE_SIZE / 2)
	position.y = snapped(position.y, TILE_SIZE / 2)

func _on_body_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("dots"):
		area.obtain()
