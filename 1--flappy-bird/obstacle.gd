extends Node2D

signal increase_score

const SPEED = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x -= SPEED

func _on_pillar_area_body_entered(body: Node2D) -> void:
	body.on_collision()

func _on_safe_area_body_entered(body: Node2D) -> void:
	increase_score.emit()
