extends Node2D

@export var car_scene: PackedScene

const SPEED = 200.00

func _process(delta: float) -> void:
	var car = car_scene.instantiate()
	car.start(SPEED)
