extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for car in get_tree().get_nodes_in_group("cars"):
		car.frog_hit.connect(_on_frog_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_frog_hit(frog):
	frog.die()
