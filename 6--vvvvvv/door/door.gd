extends Node2D

signal door_reached()

@onready var is_open = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_open and body.is_in_group("player"):
		close()
		door_reached.emit()

func open() -> void:
	is_open = true
	$SpriteClosed.visible = false
	$SpriteOpen.visible = true

func close() -> void:
	is_open = false
	$SpriteClosed.visible = true
	$SpriteOpen.visible = false
