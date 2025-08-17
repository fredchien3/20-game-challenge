extends Area2D

signal frog_hit(frog)

const SPEED = 200.0
const BUFFER_PX = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cars")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += SPEED * delta
	
	var right_bound = get_tree().get_first_node_in_group("background").get_rect().size.x
	if position.x > right_bound + BUFFER_PX:
		position.x = -BUFFER_PX

func _on_body_entered(frog: Node2D) -> void:
	frog_hit.emit(frog)
	
