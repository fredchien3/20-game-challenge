extends Node2D

signal checkpoint_reached(checkpoint_instance)

@onready var active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !active and body.is_in_group("player"):
		active = true
		$SpriteFlag.visible = false
		$SpritePole.visible = true
		checkpoint_reached.emit(self)

func set_inactive() -> void:
	active = false
	$SpriteFlag.visible = true
	$SpritePole.visible = false
