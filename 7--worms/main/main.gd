extends Node2D

@export var main_menu: CanvasLayer
@export var game_over_menu: CanvasLayer
@export var LevelScene: PackedScene
@export var winner_label: Label

var level: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


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
