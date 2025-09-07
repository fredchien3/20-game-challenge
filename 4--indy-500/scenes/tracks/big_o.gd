extends Node2D

signal finish_line_crossed(body: Node2D)

var finish_line_enabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func get_spawn_position():
	$SpawnPath/PathFollow2D.progress_ratio = randf_range(0, 1)
	return $SpawnPath/PathFollow2D.global_position


func _on_finish_line_body_entered(body: Node2D) -> void:
	if finish_line_enabled:
		finish_line_enabled = false
		finish_line_crossed.emit(body)
		$HalfwayLine/ArrowYellow.visible = true
		$FinishLine/ArrowYellow.visible = false


func _on_halfway_line_body_entered(body: Node2D) -> void:
	if !finish_line_enabled:
		finish_line_enabled = true
		$HalfwayLine/ArrowYellow.visible = false
		$FinishLine/ArrowYellow.visible = true
