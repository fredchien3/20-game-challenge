extends Node2D

var distance_traveled = 0.00
const SCROLL_SPEED = 5.00

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.position.x += SCROLL_SPEED
	$Player.position.x += SCROLL_SPEED
	
	distance_traveled += SCROLL_SPEED
	$Camera2D/DistanceLabel.text = str(int(distance_traveled / 100.0))

func _on_player_laser_on() -> void:
	$Camera2D/LaserBurst.visible = true

func _on_player_laser_off() -> void:
	$Camera2D/LaserBurst.visible = false
