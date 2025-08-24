extends Area2D

signal frog_made_it(frog)

func _ready() -> void:
	add_to_group("lilypads")

func _on_body_entered(frog: Node2D) -> void:
	frog_made_it.emit(frog)
