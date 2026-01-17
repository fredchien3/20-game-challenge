extends Node2D

signal door_reached()

@onready var open = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if open and body.is_in_group("player"):
		close()
		door_reached.emit()

func close() -> void:
	open = false
	$SpriteClosed.visible = true
	$SpriteOpen.visible = false
