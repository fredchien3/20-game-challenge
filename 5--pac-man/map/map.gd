extends Node2D

const LEFT_DESTINATION := Vector2(0, 280)
const RIGHT_DESTINATION := Vector2(448, 280)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_left_warp_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player") or
		body.is_in_group("ghosts")):
		body.position = RIGHT_DESTINATION

func _on_right_warp_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player") or
		body.is_in_group("ghosts")):
		body.position = LEFT_DESTINATION
