extends Node

const CRATER_SIDES = 24

@export var collision: CollisionPolygon2D
@export var terrain: Polygon2D


func _ready() -> void:
	collision.polygon = terrain.polygon
	collision.global_transform = terrain.global_transform

	for worm in get_tree().get_nodes_in_group("worms"):
		worm.grenade_thrown.connect(_on_worm_grenade_thrown)
		worm.bazooka_shot.connect(_on_worm_bazooka_shot)


func update_terrain_polygon():
	collision.polygon = terrain.polygon


func _on_explosion(pos, radius):
	# Local polygons need to be converted to global space to interact accurately
	var globalized_terrain_polygon = \
	terrain.global_transform * terrain.polygon

	var explosion_cutout = PackedVector2Array()
	for i in range(CRATER_SIDES):
		var angle = i * 2 * PI / CRATER_SIDES
		explosion_cutout.append(pos + Vector2(cos(angle), sin(angle)) * radius)

	var new_polygons := Geometry2D.clip_polygons(
		globalized_terrain_polygon,
		explosion_cutout,
	)

	# Global space polygons need to be converted back to local space
	# For now, we just take the leftmost polygon
	# Most likely later we will write code to take the largest polygon
	terrain.polygon = terrain.global_transform.affine_inverse() * new_polygons[0]
	call_deferred("update_terrain_polygon")


func _on_worm_grenade_thrown(grenade: Variant) -> void:
	add_child(grenade)
	grenade.exploded.connect(_on_explosion)


func _on_worm_bazooka_shot(bazooka: Variant) -> void:
	add_child(bazooka)
	bazooka.exploded.connect(_on_explosion)
