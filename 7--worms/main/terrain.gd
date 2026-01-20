extends Node

@export var test_poly: Polygon2D
@onready var collision_poly := $CollisionPolygon2D
@onready var terrain_poly := $Polygon2D

func _ready() -> void:
	test_poly.connect("clip", _on_poly_clip)
	collision_poly.polygon = terrain_poly.polygon

func _on_poly_clip():
	var new_polygon_array := Geometry2D.clip_polygons(terrain_poly.polygon, test_poly.polygon)
	terrain_poly.polygon = new_polygon_array[0]
	collision_poly.polygon = terrain_poly.polygon
	
