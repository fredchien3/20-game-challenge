extends Polygon2D

signal clip()

const AMOUNT = 10

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		position.y -= AMOUNT
	if event.is_action_pressed("ui_down"):
		position.y += AMOUNT
	if event.is_action_pressed("ui_left"):
		position.x -= AMOUNT
	if event.is_action_pressed("ui_right"):
		position.x += AMOUNT
	if event.is_action_pressed("ui_accept"):
		clip.emit()
