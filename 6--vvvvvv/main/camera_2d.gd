extends Camera2D

@onready var start_position = position
@onready var camera_width = get_viewport().size.x / zoom.x
@onready var camera_height = get_viewport().size.y / zoom.y
@onready var cooldown = 0.0

# TBD: If camera desync becomes an issue due to player speed surpassing
# the cooldown period, and the camera loses the player, a possible fix could be
# to poll the player's position and center the camera on the nearest
# camera-sized grid position that contains the player's position (math).

func _process(delta: float) -> void:
	if cooldown > 0.0: cooldown -= 0.1

func _on_bottom_area_body_entered(body: Node2D) -> void:
	if cooldown > 0: return
	
	if body.is_in_group("player"):
		body.shift("down")
		position.y += camera_height
		cooldown = 3.0

func _on_right_area_body_entered(body: Node2D) -> void:
	if cooldown > 0: return
	
	if body.is_in_group("player"):
		body.shift("right")
		position.x += camera_width
		cooldown = 3.0

func _on_top_area_body_entered(body: Node2D) -> void:
	if cooldown > 0: return
	
	if body.is_in_group("player"):
		body.shift("up")
		position.y -= camera_height
		cooldown = 3.0

func _on_left_area_body_entered(body: Node2D) -> void:
	if cooldown > 0: return
	
	if body.is_in_group("player"):
		body.shift("left")
		position.x -= camera_width
		cooldown = 3.0
