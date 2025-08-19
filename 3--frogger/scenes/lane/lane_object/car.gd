extends LaneObject

signal frog_hit(frog)

const SPEED = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cars")

func _process(delta: float) -> void:
	update_position(SPEED * delta, $CollisionShape2D.shape.size.x)

func _on_body_entered(frog: Node2D) -> void:
	frog_hit.emit(frog)
