extends Camera2D

var follow_node: Node2D = null


func _physics_process(_delta: float) -> void:
	if follow_node:
		global_position = follow_node.global_position
