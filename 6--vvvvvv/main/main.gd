extends Node2D

var latest_checkpoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	latest_checkpoint = null
	var checkpoints = get_tree().get_nodes_in_group("checkpoints")
	for checkpoint in checkpoints:
		checkpoint.connect("checkpoint_reached", _on_checkpoint_entered)
		
	var door = $Door
	door.connect("door_reached", _on_door_reached)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_checkpoint_entered(checkpoint) -> void:
	if latest_checkpoint:
		latest_checkpoint.set_inactive()

	latest_checkpoint = checkpoint
	$Player.set_spawn_position(checkpoint.global_position)

func _on_door_reached() -> void:
	$Player.queue_free()
	$Camera2D/Container/Label.visible = true
