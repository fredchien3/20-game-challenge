extends Node2D

var score
var high_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_variables()
	call_deferred("connect_dot_signals")

func connect_dot_signals():
	for dot in get_tree().get_nodes_in_group("dots"):
		dot.obtained.connect(_on_dot_obtained)
	
func init_variables():
	score = 0
	high_score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_dot_obtained():
	increment_score()
	
func increment_score():
	score += 10
	$GUI/ScoreDisplay.text = str(score)
	if score > high_score:
		high_score = score
		$GUI/HighScoreDisplay.text = str(high_score)
	
