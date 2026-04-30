extends Node3D

@export var ProjectileScene: PackedScene
@export var aimer: RigidBody3D
@export var body: CharacterBody3D
 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		# The projectile only needs to know two things:
		# Where its origin is, and what direction to face (normalized).
		var shoot_dir: Vector3 = (aimer.global_position - body.global_position).normalized()
		var projectile: RigidBody3D = ProjectileScene.instantiate()
		get_parent().add_child(projectile)
		# We can only set globalized properties after it's been added
		# to the tree.
		projectile.global_position = body.global_position
		projectile.look_at(body.global_position + shoot_dir)
