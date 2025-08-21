extends LaneObject

signal frog_hit(frog)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cars")
	super._ready()

func _on_body_entered(frog: Node2D) -> void:
	frog_hit.emit(frog)
	print(z_index)
