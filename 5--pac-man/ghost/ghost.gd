extends CharacterBody2D

const SCATTER_DURATION = 7

var movement_speed: float = 50.0
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var scatter_mode = false

func _ready():
	add_to_group("ghosts")
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 1.0

func set_movement_target(player_position: Vector2):
	if scatter_mode:
		navigation_agent.target_position = global_position - player_position
	else:
		navigation_agent.target_position = player_position

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

func trigger_scatter_mode():
	scatter_mode = true
	$Sprite2D.rotation_degrees = 90
	#await get_tree().create_timer(SCATTER_DURATION).timeout
	#trigger_chase_mode()
	
func trigger_chase_mode():
	scatter_mode = false
	$Sprite2D.rotation_degrees = 0
