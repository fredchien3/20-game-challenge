extends Node2D

@export var worm: CharacterBody2D
@export var terrain: StaticBody2D

const GrenadeScene = preload("res://weapons/grenade.tscn")

# To find a vector pointing from A to B, use B - A.
func _input(event):
	if event.is_action_pressed("shoot"):
		var b = event.position
		var a = worm.position
		var vector = b - a
		var grenade = GrenadeScene.instantiate()
		grenade.position = worm.position
		grenade.apply_impulse(vector)
		grenade.connect("explode", _on_explosion)
		add_child(grenade)
		
func _on_explosion(pos, radius):
	print("thing exploded")
	print(pos, radius)
	terrain._on_explosion(pos, radius)
