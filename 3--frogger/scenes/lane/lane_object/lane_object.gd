class_name LaneObject
extends CollisionObject2D

var velocity
var normalized_velocity

func _process(delta: float) -> void:
	normalized_velocity = velocity * delta
	update_position(normalized_velocity, $CollisionShape2D.shape.size.x)

func update_position(adjusted_speed, buffer_px) -> void:
	position.x += adjusted_speed
	
	var right_bound = get_tree()\
			.get_first_node_in_group("background")\
			.get_rect().size.x

	if position.x > right_bound + buffer_px:
		position.x = -buffer_px
	elif position.x < -buffer_px:
		position.x = right_bound + buffer_px
