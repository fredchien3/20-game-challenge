extends Node2D

@export var main_menu: CanvasLayer
@export var game_over_menu: CanvasLayer
@export var paused_menu: CanvasLayer
@export var LevelScene: PackedScene
@export var winner_label: Label

var level: Node2D


func _ready() -> void:
	game_over_menu.visible = false
	paused_menu.visible = false


func _input(event: InputEvent) -> void:
	if level and event.is_action_pressed("pause"):
		var pause_state = !get_tree().paused
		paused_menu.visible = pause_state
		get_tree().paused = pause_state


func _on_start_pressed() -> void:
	if level:
		for nodes in get_tree().get_nodes_in_group("beans"):
			nodes.remove_from_group("beans")
		level.queue_free()

	main_menu.visible = false
	game_over_menu.visible = false

	level = LevelScene.instantiate()
	level.game_over.connect(_on_game_over)
	add_child(level)


func _on_game_over(winner: String):
	if winner != "stalemate":
		winner_label.text = "Winner: " + winner.capitalize() + " Beans!"
	else:
		winner_label.text = "Stalemate!"
	game_over_menu.visible = true


func _on_continue_pressed() -> void:
	get_tree().paused = false
	paused_menu.visible = false
