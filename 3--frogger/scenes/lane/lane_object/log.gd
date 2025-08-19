extends LaneObject

const SPEED = 200.0
var velocity

func _process(delta: float) -> void:
	velocity = SPEED * delta
	update_position(velocity, $CollisionShape2D.shape.size.x)

func _on_body_entered(frog: Node2D):
	frog.follow_log(self)

func _on_body_exited(frog: Node2D) -> void:
	frog.unfollow_log(self)
