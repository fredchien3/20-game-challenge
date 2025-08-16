extends Node2D

# Todo: each lane instance should have a speed, a direction, and a number of objects.

@export var car_scene: PackedScene

var num_cars = 4

# Spawn a bunch of cars
func _ready() -> void:
	for i in range(num_cars):
		$SpawnPath/SpawnPoint.progress_ratio = randf()
		var car = car_scene.instantiate()
		car.position = $SpawnPath/SpawnPoint.position
		add_child(car)
	
func _process(_delta: float) -> void:
	pass
