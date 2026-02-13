extends RigidBody2D

signal exploded(pos, radius)

@export var EXPLOSION_RADIUS: float

var shooter: CharacterBody2D


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	rotation = linear_velocity.angle()


func _on_contact_area_body_entered(body: Node2D) -> void:
	if body == shooter:
		return
	exploded.emit(global_position, EXPLOSION_RADIUS)
	queue_free()
