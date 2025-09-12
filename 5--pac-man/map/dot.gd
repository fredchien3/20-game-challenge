extends Area2D

func _ready() -> void:
	add_to_group("coins")

func obtain():
	print("coin obtained")
	queue_free()
