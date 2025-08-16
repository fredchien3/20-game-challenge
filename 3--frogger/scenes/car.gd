extends Area2D

signal frog_hit(frog)

const SPEED = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cars")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += SPEED * delta

	var background = get_tree().get_first_node_in_group("background")
	if !Utils.in_bounds(position, background.get_rect().size):
		position.x = 0

func _on_body_entered(frog: Node2D) -> void:
	frog_hit.emit(frog)
	
