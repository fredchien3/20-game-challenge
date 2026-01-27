extends Node

@onready var collision := $CollisionPolygon2D
@onready var terrain := $Polygon2D

func _ready() -> void:
	collision.polygon = terrain.polygon
	collision.global_transform = terrain.global_transform

#func _on_poly_clip():
	## Local polygons need to be converted to global space to interact accurately
	#var globalized_terrain_polygon = \
		#terrain.global_transform * terrain.polygon
#
	#var globalized_clipper_polygon = \
		#test_clipper.global_transform * test_clipper.polygon
	#
	#var new_polygons := Geometry2D.clip_polygons(
		#globalized_terrain_polygon,
		#globalized_clipper_polygon
	#)
#
	## Global space polygons need to be converted back to local space
	## For now, we just take the leftmost polygon
	## Most likely later we will write code to take the largest polygon
	#terrain.polygon = terrain.global_transform.affine_inverse() * new_polygons[0]
	#collision.polygon = terrain.polygon
