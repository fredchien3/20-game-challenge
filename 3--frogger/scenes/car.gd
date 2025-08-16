extends StaticBody2D

var current_speed

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += current_speed * delta

func start(speed):
	current_speed = speed
