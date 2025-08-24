extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for car in get_tree().get_nodes_in_group("cars"):
		car.frog_hit.connect(_on_frog_hit)
		
	for river in get_tree().get_nodes_in_group("rivers"):
		river.frog_above_water.connect(_on_frog_above_water)
		river.frog_oob.connect(_on_frog_oob)
		
	for lilypad in get_tree().get_nodes_in_group("lilypads"):
		lilypad.frog_made_it.connect(_on_frog_made_it)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_frog_hit(frog):
	frog.die()

func _on_frog_above_water(frog):
	await get_tree().process_frame
	if !frog.following_log:
		frog.drown()
		
func _on_frog_oob(frog):
	frog.drown()

func _on_frog_made_it(frog):
	print('mama we made it')
