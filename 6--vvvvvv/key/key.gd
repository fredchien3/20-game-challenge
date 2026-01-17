extends Node2D

signal key_reached()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		key_reached.emit()
		queue_free()
