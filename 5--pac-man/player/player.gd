extends Node2D

const SPEED = 90
const TILE_SIZE = 16

@onready var current_direction = null
@onready var queued_direction = null

@onready var feelers: Dictionary[String, Area2D] = {
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
	if (queued_direction and
		queued_direction != current_direction and
		can_move_towards(queued_direction)):
			snap_to_grid()
			current_direction = queued_direction
			queued_direction = null
	
	match current_direction:
		"up":
			if can_move_towards("up"):
				position.y -= SPEED * delta
			else:
				snap_to_grid()
				current_direction = null
		"down":
			if can_move_towards("down"):
				position.y += SPEED * delta
			else:
				snap_to_grid()
				current_direction = null
		"left":
			if can_move_towards("left"):
				position.x -= SPEED * delta
			else:
				snap_to_grid()
				current_direction = null
		"right":
			if can_move_towards("right"):
				position.x += SPEED * delta
			else:
				snap_to_grid()
				current_direction = null
		_:
			pass

func _input(event):
	if event.is_action_pressed("move_up") and current_direction != "up":
		queued_direction = "up"
	elif event.is_action_pressed("move_down") and current_direction != "down":
		queued_direction = "down"
	elif event.is_action_pressed("move_left") and current_direction != "left":
		queued_direction = "left"
	elif event.is_action_pressed("move_right") and current_direction != "right":
		queued_direction = "right"

func snap_to_grid():
	position.x = snapped(position.x, TILE_SIZE / 2)
	position.y = snapped(position.y, TILE_SIZE / 2)
		
func can_move_towards(direction: String) -> bool:
	return feelers[direction].get_overlapping_bodies().is_empty()

func _on_body_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("dots"):
		area.obtain()
