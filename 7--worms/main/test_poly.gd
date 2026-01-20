extends Polygon2D

signal clip()

const AMOUNT = 10
func _input(event: InputEvent) -> void:
	var new_polygon: PackedVector2Array = []
	if event.is_action_pressed("ui_up"):
		for vector in polygon:
			vector.y -= AMOUNT
			new_polygon.append(vector)
			set_polygon(new_polygon)
	if event.is_action_pressed("ui_down"):
		for vector in polygon:
			vector.y += AMOUNT
			new_polygon.append(vector)
			set_polygon(new_polygon)
	if event.is_action_pressed("ui_left"):
		for vector in polygon:
			vector.x -= AMOUNT
			new_polygon.append(vector)
			set_polygon(new_polygon)
	if event.is_action_pressed("ui_right"):
		for vector in polygon:
			vector.x += AMOUNT
			new_polygon.append(vector)
			set_polygon(new_polygon)
	if event.is_action_pressed("ui_accept"):
		clip.emit()
