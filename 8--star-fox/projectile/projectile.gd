extends RigidBody3D

@export var speed: float = 20.0

func _ready() -> void:
	await get_tree().create_timer(10).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	linear_velocity = -basis.z * speed

func _on_hitbox_area_body_entered(body: Node3D) -> void:
	if body.has_method("hit_by_projectile"):
		body.hit_by_projectile()

	queue_free()
