extends Area2D

signal frog_entered(frog)

var occupied = false

func _ready() -> void:
	add_to_group("lilypads")

func _on_area_entered(frog: Area2D) -> void:
	if not occupied:
		frog_entered.emit(frog)
		occupied = true
		$AnimatedSprite2D.animation = "with_frog"
	else:
		frog.drown()

func reset() -> void:
	occupied = false
	$AnimatedSprite2D.animation = "default"
