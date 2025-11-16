extends Camera2D
# Math time.
# Viewport width / camera_zoom_level = current camera width
# width / 2 = initial offset
# width + width = next screen over

# Viewport height / camera_zoom_level = current camera height
# height / 2 = initial offset
# height + height = next screen below

var start_position: Vector2
var camera_width
var camera_height

func _ready() -> void:
	start_position = position
	camera_width = get_viewport().size.x / zoom.x
	camera_height = get_viewport().size.y / zoom.y
	
	#horizontal_offset = camera_width / 2.0
	#vertical_offset = camera_height / 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# debugging purposes
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("w"):
		position.y -= camera_height
	if event.is_action_pressed("a"):
		position.x -= camera_width
	if event.is_action_pressed("s"):
		position.y += camera_height
	if event.is_action_pressed("d"):
		position.x += camera_width
		

func _on_bottom_area_body_entered(body: Node2D) -> void:
	position.y += camera_height

func _on_right_area_body_entered(body: Node2D) -> void:
	position.x += camera_width

func _on_top_area_body_entered(body: Node2D) -> void:
	position.y -= camera_height

func _on_left_area_body_entered(body: Node2D) -> void:
	position.x -= camera_width
