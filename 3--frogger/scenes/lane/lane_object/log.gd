extends LaneObject

func _on_body_entered(frog: Node2D):
	frog.follow_log(self)

func _on_body_exited(frog: Node2D) -> void:
	frog.unfollow_log(self)
