class_name Utils

static func in_bounds(position, map_size) -> bool:
	if position.x < -24 or position.y < 0:
		return false
		
	if position.x >= map_size[0] - 24 or position.y >= map_size[1]:
		return false
		
	return true
