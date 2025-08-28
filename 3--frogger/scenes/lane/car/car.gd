extends LaneObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi() % 2:
		$AnimatedSprite2D.animation = "purple"
	else:
		$AnimatedSprite2D.animation = "red"

	add_to_group("cars")
	super._ready()
