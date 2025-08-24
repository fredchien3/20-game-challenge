extends Node2D

#signal frog_above_water
#signal frog_oob(frog)

@export_enum("Road", "River") var lane_type: String


const TYPE_TO_OBJECT_PATH_MAP = {
	"Road": "res://scenes/lane/lane_object/car.tscn",
	"River": "res://scenes/lane/lane_object/log.tscn",
}
const DIRECTIONS = [-1, 1]

var num_objects = randi_range(4, 6)
var spawn_path_fraction = 10

var min_speed = 1
var max_speed = 200

func establish_lane_type_variables():
	if lane_type == "River":
		add_to_group("rivers")
		$ColorRect.color = "blue"
		num_objects = randi_range(3, 5)
		spawn_path_fraction = 5
		min_speed = 125
		max_speed = 150

func _ready() -> void:
	establish_lane_type_variables()
	var path = TYPE_TO_OBJECT_PATH_MAP[lane_type]
	var object_scene = load(path)

	var direction = DIRECTIONS[randi_range(0, 1)]
	var speed = randi_range(min_speed, max_speed)
	var velocity = direction * speed

	# TODO: This spawns objects inside each other. Low priority
	for i in range(num_objects):
		# Pick a random point to spawn, rounded to the nearest N-th
		# so objects don't partially overlap
		$SpawnPath/SpawnPoint.progress_ratio = \
				floor(randf() * spawn_path_fraction) / spawn_path_fraction

		var object = object_scene.instantiate()
		object.position = $SpawnPath/SpawnPoint.position
		object.velocity = velocity
		add_child(object)

func _on_death_zone_area_entered(area: Area2D) -> void:
	if area.has_method("drown"):
		area.drown()
