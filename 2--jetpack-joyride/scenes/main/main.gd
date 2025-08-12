extends Node2D

@export var obstacle_scene: PackedScene

var high_score = 0
var distance_traveled = 0.00

var player_alive = true

const DEFAULT_SCROLL_SPEED = 5.00
var scroll_speed = DEFAULT_SCROLL_SPEED


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player_alive and scroll_speed >= 0.01:
		scroll_speed -= 0.01

	$SlidingNode.position.x += scroll_speed
	distance_traveled += scroll_speed
	$SlidingNode/Camera2D/DistanceLabel.text = str(int(distance_traveled / 100.0))
	
	var spawn_y = randf_range(-(1920/2), 1920/2)
	
func _on_player_laser_on() -> void:
	$SlidingNode/LaserBurst.visible = true

func _on_player_laser_off() -> void:
	$SlidingNode/LaserBurst.visible = false

func _on_obstacle_spawn_timer_timeout() -> void:
	spawn_obstacle()
	$ObstacleSpawnTimer.wait_time = randf_range(1, 2)

func spawn_obstacle() -> void:
	var obstacle_spawn_location = $SlidingNode/ObstacleSpawnPath/ObstacleSpawnLocation
	obstacle_spawn_location.progress_ratio = randf()
	
	var obstacle = obstacle_scene.instantiate()
	
	obstacle.add_to_group("obstacles")
	obstacle.position = obstacle_spawn_location.global_position
	
	add_child(obstacle)


func _on_player_death() -> void:
	player_alive = false
	$ObstacleSpawnTimer.stop()
