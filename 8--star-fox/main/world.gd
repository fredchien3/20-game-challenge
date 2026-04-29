extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ship = get_tree().get_nodes_in_group("ship")[0]
	ship.projectile_shot.connect(_on_ship_projectile_shot)


func _physics_process(delta: float) -> void:
	var ratio_delta = 0.0005
	if Input.is_action_pressed("ui_right"):
		$Rail/RailFollow.progress_ratio += ratio_delta
	if Input.is_action_pressed("ui_left"):
		$Rail/RailFollow.progress_ratio -= ratio_delta

func _on_ship_projectile_shot(projectile: RigidBody3D):
	add_child(projectile)
