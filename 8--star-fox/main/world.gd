extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ship = get_tree().get_nodes_in_group("ship")[0]
	ship.projectile_shot.connect(_on_ship_projectile_shot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ship_projectile_shot(projectile: RigidBody3D):
	add_child(projectile)
