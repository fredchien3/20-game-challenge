extends RigidBody3D

@export var speed: float

func _ready() -> void:
	linear_velocity = -global_transform.basis.z * speed
	await get_tree().create_timer(10).timeout
	queue_free()


func _on_hitbox_area_body_entered(body: Node3D) -> void:
	if body.has_method("hit_by_projectile"):
		body.hit_by_projectile()

	queue_free()
