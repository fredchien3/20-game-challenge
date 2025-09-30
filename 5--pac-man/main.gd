extends Node2D

var score
var high_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_variables()
	call_deferred("connect_pickup_signals")

func connect_pickup_signals():
	for dot in get_tree().get_nodes_in_group("dots"):
		dot.obtained.connect(_on_dot_obtained)
	for power_pellet in get_tree().get_nodes_in_group("power_pellets"):
		power_pellet.obtained.connect(_on_power_pellet_obtained)

func init_variables():
	score = 0
	high_score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_dot_obtained():
	increment_score(10)
	
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


func _on_player_died() -> void:
	get_tree().call_group("ghosts", "queue_free")
