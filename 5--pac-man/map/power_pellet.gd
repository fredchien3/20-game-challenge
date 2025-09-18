extends Area2D

signal obtained

func _ready() -> void:
	add_to_group("power_pellets")

func obtain():
	obtained.emit()
	queue_free()
