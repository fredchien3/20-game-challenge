extends Node2D

var frogs_in_lilypads = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for lilypad in get_tree().get_nodes_in_group("lilypads"):
		lilypad.frog_made_it.connect(_on_frog_made_it)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_frog_made_it(frog):
	frogs_in_lilypads += 1
	if frogs_in_lilypads == 5:
		print('you win')
