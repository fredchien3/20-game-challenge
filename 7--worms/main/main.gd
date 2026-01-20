extends Node2D

@export var test_node: Node
@export var terrain_node: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test_node.connect("clip", _on_poly_clip)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_poly_clip():
	var new_polygon_array := Geometry2D.clip_polygons(terrain_node.polygon, test_node.polygon)
	
	terrain_node.polygon = new_polygon_array[0]
