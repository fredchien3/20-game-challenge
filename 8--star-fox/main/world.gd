extends Node3D

@export var rail_follow: PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var ratio_per_second = 0.01 * delta
	rail_follow.progress_ratio += ratio_per_second
	
	if Input.is_action_pressed("ui_right"):
		$Rail/RailFollow.progress_ratio += ratio_per_second * 2
	if Input.is_action_pressed("ui_left"):
		$Rail/RailFollow.progress_ratio -= ratio_per_second * 2
