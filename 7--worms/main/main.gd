extends Node2D

@export var worm: CharacterBody2D
@export var terrain: StaticBody2D


func _on_worm_grenade_thrown(grenade: Variant) -> void:
	add_child(grenade)
	grenade.exploded.connect(_on_explosion)


func _on_explosion(pos, radius):
	terrain._on_explosion(pos, radius)
