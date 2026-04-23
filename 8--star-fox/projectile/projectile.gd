extends RigidBody3D

@export var speed: Vector3

func _ready() -> void:
	linear_velocity = speed
	await get_tree().create_timer(10).timeout
	queue_free()


func _on_hitbox_area_body_entered(body: Node3D) -> void:
	if body.has_method("hit_by_projectile"):
		body.hit_by_projectile()

	queue_free()
