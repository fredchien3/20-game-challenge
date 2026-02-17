extends Node2D

@export var MainMenu: CanvasLayer
@export var GameOverMenu: CanvasLayer
@export var LevelScene: PackedScene
@export var Winner: Label

var level: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	if level:
		level.queue_free()

	MainMenu.visible = false
	GameOverMenu.visible = false

	level = LevelScene.instantiate()
	level.game_over.connect(_on_game_over)
	add_child(level)


func _on_game_over(winner: CharacterBody2D):
	if winner:
		Winner.text = "Winner: " + winner.to_string()
	else:
		Winner.text = "Stalemate!"
	GameOverMenu.visible = true
