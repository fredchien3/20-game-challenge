extends Node2D

@export var obstacle_scene: PackedScene

const OBSTACLE_GAP_RADIUS = 50

var current_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScoreLabel.text = str(current_score)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_obstacle_spawn_timer_timeout() -> void:
	var obstacle = obstacle_scene.instantiate()

	obstacle.increase_score.connect(_add_point)

	var viewport_width = get_viewport().size[0]
	var viewport_height = get_viewport().size[1]

	var spawn_x = (viewport_width / 2) + 60
	var y_bound = (viewport_height / 2)
	var spawn_y = randf_range(y_bound, -y_bound)

	obstacle.position = Vector2(spawn_x, spawn_y)

	add_child(obstacle)

func _add_point():
	current_score += 1
	$ScoreLabel.text = str(current_score)

func _on_fish_death() -> void:
	$ObstacleSpawnTimer.stop()

	var obstacles = get_tree().get_nodes_in_group("obstacles")

	for node in obstacles:
		node.set_process(false)

	await get_tree().create_timer(3).timeout

	get_tree().reload_current_scene()

func _on_area_2d_body_entered(body: Node2D) -> void:
	$Fish.on_collision()
