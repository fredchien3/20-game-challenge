extends Node2D

var score
var high_score = 0
var lives

var initial_player_position
var initial_ghost_positions = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_game_variables()
	call_deferred("connect_pickup_signals")
	call_deferred("connect_player_signals", $Player)
	
	# Save the initial player + ghost positions, for respawn purposes
	initial_player_position = get_tree().get_first_node_in_group("player").position
	for ghost in get_tree().get_nodes_in_group("ghosts"):
		initial_ghost_positions[ghost.ghost_name] = ghost.position

func new_game() -> void:
	reset_game_variables()
	reset_map()
	respawn_characters()

func reset_game_variables():
	score = 0
	lives = 2
	$GUI/ScoreDisplay.text = str(score)
	$GUI/LifeDisplay1.visible = true
	$GUI/LifeDisplay2.visible = true
	$GUI/GameOverDisplay.visible = false

func connect_pickup_signals():
	for dot in get_tree().get_nodes_in_group("dots"):
		if not dot.obtained.is_connected(_on_dot_obtained):
			dot.obtained.connect(_on_dot_obtained)
	for power_pellet in get_tree().get_nodes_in_group("power_pellets"):
		if not power_pellet.obtained.is_connected(_on_power_pellet_obtained):
			power_pellet.obtained.connect(_on_power_pellet_obtained)

func connect_player_signals(player: CharacterBody2D):
	player.ghost_eaten.connect(_on_player_ghost_eaten)
	player.death_started.connect(_on_player_death_started)
	player.death_finished.connect(_on_player_death_finished)

## Creates a brand new instance of the map and all pickups
func reset_map():
	var new_map = load("res://map/map.tscn").instantiate()
	get_tree().call_group("map", "queue_free")
	new_map.add_to_group("map")
	add_child(new_map)
	move_child(new_map, 0)
	call_deferred("connect_pickup_signals")
	
func _on_dot_obtained():
	increment_score(10)
	get_tree().process_frame.connect(check_win_condition, CONNECT_ONE_SHOT)

func check_win_condition():
	if get_tree().get_nodes_in_group("dots").size() < 1:
		you_win()
	
func _on_power_pellet_obtained():
	get_tree().call_group("ghosts", "trigger_scatter_mode")
	
func increment_score(amount: int):
	score += amount
	$GUI/ScoreDisplay.text = str(score)
	if score > high_score:
		high_score = score
		$GUI/HighScoreDisplay.text = str(high_score)

func _on_ghost_target_poll_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player: return
	
	for ghost in get_tree().get_nodes_in_group("ghosts"):
		if player.alive:
			ghost.set_movement_target(player.global_position, player.facing)
		else:
			ghost.process_mode = Node.PROCESS_MODE_DISABLED

func _on_player_ghost_eaten() -> void:
	increment_score(333)

func _on_player_death_started() -> void:
	get_tree().call_group("ghosts", "queue_free")

func _on_player_death_finished() -> void:
	await get_tree().create_timer(2).timeout
	decrement_lives()
	if lives >= 0:
		respawn_characters()

func respawn_characters():
	# Respawn player
	get_tree().call_group("player", "queue_free")
	var player = load("res://player/player.tscn").instantiate()
	player.position = initial_player_position
	connect_player_signals(player)
	add_child(player)
	
	# Respawn ghosts
	var ghost_scene = load("res://ghost/ghost.tscn")
	get_tree().call_group("ghosts", "queue_free")
	for ghost_name in initial_ghost_positions.keys():
		var ghost = ghost_scene.instantiate()
		ghost.ghost_name = ghost_name
		ghost.position = initial_ghost_positions[ghost_name]
		ghost.spawn_point = initial_ghost_positions[ghost_name]
		add_child(ghost)
		
func decrement_lives() -> void:
	lives -= 1
	if $GUI/LifeDisplay1.visible:
		$GUI/LifeDisplay1.visible = false
	else:
		$GUI/LifeDisplay2.visible = false

	if lives < 0:
		game_over()

func game_over() -> void:
	$GUI/GameOverDisplay/Label.text = "Game over!"
	$GUI/GameOverDisplay.visible = true
	get_tree().call_group("player", "pause")
	get_tree().call_group("ghosts", "queue_free")
	
func you_win() -> void:
	$GUI/GameOverDisplay/Label.text = "You win!"
	$GUI/GameOverDisplay.visible = true
	get_tree().call_group("player", "pause")
	get_tree().call_group("ghosts", "queue_free")

func _on_new_game_button_pressed() -> void:
	get_tree().paused = false
	new_game()
