extends Node2D

const TRACK_PATHS = ["res://scenes/tracks/big_o.tscn", "res://scenes/tracks/lazy_eight.tscn"]

func _ready() -> void:
	$MainMenu/TrackSelector.get_popup().id_pressed.connect(_on_track_selected)
	
	# debug
	#_on_track_selected(0)

func _process(_delta: float) -> void:
	pass

func _on_track_selected(id):
	# Load track
	var track = load(TRACK_PATHS[id]).instantiate()
	add_child(track)
	
	# Load car, attach camera
	var car = load("res://scenes/car/car.tscn").instantiate()
	car.player_num = 1
	#$GameCamera.reparent(car)
	
	print(track.get_spawn_position)
	
	car.position = track.get_spawn_position()
	car.rotation_degrees = -90
	add_child(car)

	$MainMenu.visible = false
