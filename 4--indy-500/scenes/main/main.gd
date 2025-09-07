extends Node2D

const TRACK_PATHS = ["res://scenes/tracks/big_o.tscn", "res://scenes/tracks/lazy_eight.tscn"]

var laps_complete = 0
var laps_needed = 3

func _ready() -> void:
	$MainMenu/TrackSelector.get_popup().id_pressed.connect(_on_track_selected)
	
	# debug
	_on_track_selected(0)

func _process(_delta: float) -> void:
	pass

func _on_track_selected(id):
	# Load track
	var track = load(TRACK_PATHS[id]).instantiate()
	track.finish_line_crossed.connect(_on_finish_line_crossed)
	add_child(track)
	
	# Load car, attach camera
	var car = load("res://scenes/car/car.tscn").instantiate()
	car.player_num = 1
	$GameCamera.reparent(car)

	car.position = track.get_spawn_position()
	car.rotation_degrees = -90
	add_child(car)

	$MainMenu.visible = false
	
	$HUD/LapCounter.text = str(laps_complete) + "/" + str(laps_needed) + " laps"
	$HUD/LapCounter.visible = true

func _on_finish_line_crossed(_body):
	laps_complete += 1
	$HUD/LapCounter.text = str(laps_complete) + "/" + str(laps_needed) + " laps"
	if laps_complete == 3:
		print("you win")
