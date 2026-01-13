extends Camera2D

@onready var start_position = position
@onready var camera_width = get_viewport().size.x / zoom.x
@onready var camera_height = get_viewport().size.y / zoom.y
@onready var camera_x_offset = camera_width / 2
@onready var camera_y_offset = camera_height / 2

var player

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func center_on(node):
	var node_pos = node.global_position
	
	var num_camera_widths = floor(node_pos.x / camera_width)
	var num_camera_heights = floor(node_pos.y / camera_height)
	
	var x = (num_camera_widths * camera_width) + camera_x_offset
	var y = (num_camera_heights * camera_height) + camera_y_offset
	
	global_position = Vector2(x, y)

func _on_timer_timeout() -> void:
	if player: center_on(player)
