extends Node2D

@export var terrain: StaticBody2D


func _ready() -> void:
	for worm in get_tree().get_nodes_in_group("worms"):
		worm.grenade_thrown.connect(_on_worm_grenade_thrown)
		worm.bazooka_shot.connect(_on_worm_bazooka_shot)


func _on_worm_grenade_thrown(grenade: Variant) -> void:
	add_child(grenade)
	grenade.exploded.connect(_on_explosion)


func _on_worm_bazooka_shot(bazooka: Variant) -> void:
	add_child(bazooka)
	bazooka.exploded.connect(_on_explosion)


func _on_explosion(pos, radius):
	terrain._on_explosion(pos, radius)
