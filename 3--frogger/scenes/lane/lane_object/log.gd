extends LaneObject

const SPEED = 200.0

func _process(delta: float) -> void:
	update_position(SPEED * delta, $CollisionShape2D.shape.size.x)
