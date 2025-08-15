extends Node2D

@export var obstacle_scene: PackedScene

var high_score = 0.00
var distance_traveled = 0.00

# 0: running
# 1: dying
var game_state = 0

const DEFAULT_SCROLL_SPEED = 5.00
var scroll_speed = DEFAULT_SCROLL_SPEED


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_state == 1:
		if scroll_speed >= 0.00:
			scroll_speed -= 0.02
		else:
			scroll_speed = 0
			game_state = 2
			display_game_over()
	$SlidingNode.position.x += scroll_speed
	distance_traveled += scroll_speed
	$GUI/DistanceLabel.text = display_distance(distance_traveled)

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
	game_state = 1
	$ObstacleSpawnTimer.stop()
	
func display_game_over() -> void:
	if distance_traveled > high_score:
		high_score = distance_traveled

	$GUI/GameOverControl/Label.text = "You died!\n" \
		+ "Your score was: " \
		+ display_distance(distance_traveled)
		
	$GUI/GameOverControl.visible = true

func display_distance(distance: float) -> String:
	return str(int(distance / 100.0)) + " kp"

func _on_button_pressed() -> void:
	# Clear the screen
	$GUI/GameOverControl.visible = false
	get_tree().call_group("obstacles", "queue_free")

	# Update the high score
	$GUI/HighScoreLabel.text = "High score: " + display_distance(high_score)
	$GUI/HighScoreLabel.visible = true
	
	# Get things going again
	distance_traveled = 0.00
	game_state = 0
	scroll_speed = DEFAULT_SCROLL_SPEED
	$SlidingNode/Player.respawn()
	$SlidingNode/Player.position.y = 0
	$ObstacleSpawnTimer.start()
