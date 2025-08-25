extends Area2D

signal frog_entered(frog)

var occupied = false

func _ready() -> void:
	add_to_group("lilypads")

func _on_area_entered(frog: Area2D) -> void:
	if not occupied:
		frog_entered.emit(frog)
		occupied = true
		add_child(frog.get_child(0).duplicate())
	else:
		frog.drown()
