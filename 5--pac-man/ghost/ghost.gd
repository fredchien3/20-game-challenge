extends CharacterBody2D

@export_enum("blinky", "pinky", "inky", "clide") var ghost_name: String

const SCATTER_DURATION = 7
const TILE_SIZE = 16

var movement_speed: float = 50.0
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var scatter_mode = false

func _ready():
	add_to_group("ghosts")
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 1.0
	match ghost_name:
		"blinky": $Sprite2D.modulate = Color("red")
		"pinky": $Sprite2D.modulate = Color("pink")
		"inky": $Sprite2D.modulate = Color("blue")
		"clide": $Sprite2D.modulate = Color("orange")

func set_movement_target(player_position: Vector2, player_facing: Vector2):
	if scatter_mode:
		flee(player_position)
	else:
		match ghost_name:
			"blinky": chase(player_position)
			"pinky": cut_off(player_position, player_facing)
			"inky": chase(player_position)
			"clide": flee(player_position)
			_: chase(player_position)

func chase(player_position: Vector2):
	navigation_agent.target_position = player_position

func cut_off(player_position: Vector2, player_facing: Vector2):
	print(player_facing * TILE_SIZE)
	navigation_agent.target_position = player_position + (player_facing * TILE_SIZE * 4)

# Currently:
# ghost pos - player pos = vector pointing from the player to the ghost
# We transform that vector to_global (but originating at the ghost's pos)
# giving us a target position that is essentially "away from the player"
# This makes the ghost prone to getting stuck in the map corners, and
# isn't how the ghosts behave in the original, but it will do for now
func flee(player_position: Vector2):
	navigation_agent.target_position = to_global(global_position - player_position)

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
	await get_tree().create_timer(SCATTER_DURATION).timeout
	trigger_chase_mode()
	
func trigger_chase_mode():
	scatter_mode = false
	$Sprite2D.rotation_degrees = 0
