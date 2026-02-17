extends Node2D

@export var MainMenu: CanvasLayer
@export var LevelScene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	MainMenu.visible = false
	add_child(LevelScene.instantiate())
