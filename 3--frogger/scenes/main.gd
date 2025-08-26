extends Node2D

var score = 0
var num_lives = 3
const SPAWN_POSITION = [448, 1024]

const SPAWN_DELAY = 2

func _ready() -> void:
	for lilypad in get_tree().get_nodes_in_group("lilypads"):
		lilypad.frog_entered.connect(_on_frog_entered)

	update_lives_display()

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
		#start_game($Frog)
	#pass

func _on_frog_entered(frog):
	score += 1
	if score == 5:
		game_over(frog, "You win!")
	else:
		reset_position(frog)

func _on_frog_death(frog: Variant) -> void:
	num_lives -= 1
	update_lives_display()

	if num_lives == 0:
		game_over(frog, "Game over!")
		return
	
	await get_tree().create_timer(SPAWN_DELAY).timeout
	reset_position(frog)
	frog.revive()

func reset_position(frog):
	frog.position = Vector2(SPAWN_POSITION[0], SPAWN_POSITION[1])
	
func update_lives_display():
	if num_lives == 0:
		$NumLivesGui/NumLives.text = ""
	else:
		var display_lives = ""
		for i in range(num_lives):
			display_lives += "🐸"
			$NumLivesGui/NumLives.text = display_lives
			
func game_over(frog, display_text):
	frog.alive = false
	$GameOverGui/MainText.text = display_text
	$GameOverGui.visible = true

func start_game():
	$GameOverGui.visible = false
	
	var frog = $Frog
	reset_position(frog)
	frog.revive()
	
	num_lives = 3
	update_lives_display()
	
	get_tree().call_group("roads", "reset")
	get_tree().call_group("rivers", "reset")
	get_tree().call_group("lilypads", "reset")

func _on_restart_pressed() -> void:
	start_game()
