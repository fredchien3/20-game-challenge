extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_spawn_position():
	$SpawnPath/PathFollow2D.progress_ratio = randf_range(0, 1)
	return $SpawnPath/PathFollow2D.global_position
