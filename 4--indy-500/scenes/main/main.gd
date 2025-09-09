extends Node2D

const TRACK_PATHS = ["res://scenes/tracks/big_o.tscn", "res://scenes/tracks/lazy_eight.tscn"]
var track

var laps_complete
var laps_needed

var game_running
var elapsed_time

func reset_variables():
	laps_complete = 0
	laps_needed = 1
	game_running = false
	elapsed_time = 0.0

	$MainMenu.visible = true
	$HUD.visible = false
	$HUD/LapLabel.text = str(laps_complete) + "/" + str(laps_needed) + " laps"
	$HUD/WinLabel.text += "\n" + str(snapped(elapsed_time, 0.01)) + " seconds"

func _ready() -> void:
	reset_variables()
	$MainMenu/TrackSelector.get_popup().id_pressed.connect(_on_track_selected)
	# debug
	#_on_track_selected(0)

func _process(delta: float) -> void:
	if game_running:
		elapsed_time += delta
		$HUD/TimeLabel.text = str(snapped(elapsed_time, 0.01))

func _on_track_selected(id):
	# Load track
	track = load(TRACK_PATHS[id]).instantiate()
	track.finish_line_crossed.connect(_on_finish_line_crossed)
	add_child(track)
	
	var track_bounds = track.get_right_and_bottom_bounds()
	$GameCamera.limit_right = track_bounds[0]
	$GameCamera.limit_bottom = track_bounds[1]
	
	# Load car
	var car: RigidBody2D = load("res://scenes/car/car.tscn").instantiate()
	car.freeze = true
	car.player_num = 1
	$GameCamera.reparent(car)

	car.position = track.get_spawn_position()
	car.rotation_degrees = -90
	track.add_child(car)

	$MainMenu.visible = false
	$HUD.visible = true
	$HUD/WinLabel.visible = false
	
	$HUD/CountdownLabel.text = "3"
	await get_tree().create_timer(1).timeout
	$HUD/CountdownLabel.text = "2"
	await get_tree().create_timer(1).timeout
	$HUD/CountdownLabel.text = "1"
	await get_tree().create_timer(1).timeout
	$HUD/CountdownLabel.text = "Start!"
	game_running = true
	car.freeze = false
	await get_tree().create_timer(0.5).timeout
	$HUD/CountdownLabel.text = ""

func _on_finish_line_crossed(_body):
	laps_complete += 1
	$HUD/LapLabel.text = str(laps_complete) + "/" + str(laps_needed) + " laps"
	if laps_complete == laps_needed:
		game_running = false
		track.end_game()
		$HUD/WinLabel.text = "You win!\n" + str(snapped(elapsed_time, 0.01)) + " seconds"
		$HUD/WinLabel.visible = true


func _on_main_menu_button_pressed() -> void:
	if track:
		track.queue_free()
	reset_variables()
