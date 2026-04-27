extends Node3D
@export var ProjectileScene: PackedScene
@export var body: CharacterBody3D
signal projectile_shot(projectile)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var projectile: RigidBody3D = ProjectileScene.instantiate()
		projectile.global_position = body.global_position
		projectile_shot.emit(projectile)
