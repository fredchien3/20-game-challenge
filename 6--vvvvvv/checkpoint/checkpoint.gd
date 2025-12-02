extends Node2D

signal checkpoint_reached(checkpoint_instance)

@onready var fresh = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if fresh and body.is_in_group("player"):
		fresh = false
		$SpriteFresh.visible = false
		$SpriteUsed.visible = true
		checkpoint_reached.emit(self)
