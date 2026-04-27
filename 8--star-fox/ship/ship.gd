extends Node3D

signal projectile_shot(projectile)

@export var ProjectileScene: PackedScene
@export var body: CharacterBody3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var projectile: RigidBody3D = ProjectileScene.instantiate()
		projectile.position = body.global_position 
		projectile.basis = body.basis
		projectile_shot.emit(projectile)
