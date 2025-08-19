extends Node2D

@export_enum("Road", "River") var lane_type: String

var type_to_object_path_map = {
	"Road": "res://scenes/lane/lane_object/car.tscn",
	"River": "res://scenes/lane/lane_object/log.tscn",
}

var num_objects = randi_range(4,8)

var spawn_path_fraction = 10

func _ready() -> void:
	if lane_type == "River":
		$ColorRect.color = "blue"
		num_objects = randi_range(2, 4)
		spawn_path_fraction = 5

	var path = type_to_object_path_map[lane_type]
	var object_scene = load(path)

	for i in range(num_objects):
		# Pick a random point to spawn, rounded to the nearest N-th
		# so objects don't spawn inside each other
		$SpawnPath/SpawnPoint.progress_ratio = \
				floor(randf() * spawn_path_fraction) / spawn_path_fraction

		var object = object_scene.instantiate()
		object.position = $SpawnPath/SpawnPoint.position
		add_child(object)
	
func _process(_delta: float) -> void:
	pass
