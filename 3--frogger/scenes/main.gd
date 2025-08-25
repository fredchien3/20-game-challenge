extends Node2D

var score = 0
var num_lives = 3
const SPAWN_POSITION = [448, 1024]

const SPAWN_DELAY = 2

func _ready() -> void:
	for lilypad in get_tree().get_nodes_in_group("lilypads"):
		lilypad.frog_entered.connect(_on_frog_entered)
	update_lives_display()

func _process(_delta: float) -> void:
	pass

func _on_frog_entered(frog):
	score += 1
	if score == 5:
		game_won(frog)
	else:
		reset_position(frog)

func _on_frog_death(frog: Variant) -> void:
	if num_lives == 0:
		game_over(frog)
		return
	
	await get_tree().create_timer(SPAWN_DELAY).timeout
	reset_position(frog)
	frog.revive()
	num_lives -= 1
	update_lives_display()
	
func reset_position(frog):
	frog.position = Vector2(SPAWN_POSITION[0], SPAWN_POSITION[1])
	
func update_lives_display():
	if num_lives == 0:
		$GUI/NumLives.text = ""
	else:
		var display_lives = ""
		for i in range(num_lives):
			display_lives += "🐸"
			$GUI/NumLives.text = display_lives
			
func game_won(frog):
	$GUI/MainText.text = "You win!"
	$GUI/MainText.visible = true
	frog.alive = false

func game_over(frog):
	$GUI/MainText.text = "Game over!"
	$GUI/MainText.visible = true
	frog.alive = false
