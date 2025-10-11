extends Area2D

signal obtained

func _ready() -> void:
	add_to_group("dots")

func obtain():
	queue_free()
	obtained.emit()
