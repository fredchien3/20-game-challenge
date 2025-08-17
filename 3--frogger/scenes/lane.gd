extends Node2D

@export var car_scene: PackedScene

var num_cars = randi_range(5,8)

func _ready() -> void:
	for i in range(num_cars):
		# Pick a random point to spawn, rounded to the nearest tenth
		# so cars don't spawn inside each other
		$SpawnPath/SpawnPoint.progress_ratio = floor(randf() * 10) / 10
		var car = car_scene.instantiate()
		car.position = $SpawnPath/SpawnPoint.position
		add_child(car)
	
func _process(_delta: float) -> void:
	pass
