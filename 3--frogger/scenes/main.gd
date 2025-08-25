extends Node2D

var score = 0
var num_lives = 3
const SPAWN_POSITION = [448, 1024]

func _ready() -> void:
	for lilypad in get_tree().get_nodes_in_group("lilypads"):
		lilypad.frog_made_it.connect(_on_frog_made_it)
		
	var display_lives = ""
	for i in range(num_lives):
		display_lives += "🐸"
	$GUI/NumLives.text = display_lives

func _process(_delta: float) -> void:
	pass

func _on_frog_made_it(frog):
	score += 1
	if score == 5:
		$GUI/YouWin.visible = true

	respawn_frog(frog)

func respawn_frog(frog):
	frog.position = Vector2(SPAWN_POSITION[0], SPAWN_POSITION[1])
