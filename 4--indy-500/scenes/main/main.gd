extends Node2D

const TRACK_PATHS = ["res://scenes/tracks/big_o.tscn", "res://scenes/tracks/lazy_eight.tscn"]
var track

var laps_complete = 0
var laps_needed = 1

var game_running = false
var elapsed_time = 0.0

func _ready() -> void:
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
	
	# Load car
	var car = load("res://scenes/car/car.tscn").instantiate()
	car.player_num = 1
	#$GameCamera.reparent(car)

	car.position = track.get_spawn_position()
	car.rotation_degrees = -90
	add_child(car)

	$MainMenu.visible = false
	
	$HUD/LapLabel.text = str(laps_complete) + "/" + str(laps_needed) + " laps"
	$HUD.visible = true
	game_running = true

func _on_finish_line_crossed(_body):
	laps_complete += 1
	$HUD/LapLabel.text = str(laps_complete) + "/" + str(laps_needed) + " laps"
	if laps_complete == laps_needed:
		$HUD/WinLabel.visible = true
		game_running = false
		track.end_game()
		$HUD/WinLabel.text += "\n" + str(snapped(elapsed_time, 0.01)) + " seconds"
