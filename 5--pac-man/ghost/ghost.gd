extends CharacterBody2D

@export_enum("blinky", "pinky", "inky", "clide") var ghost_name: String

const SCATTER_DURATION = 5.0
const CLIDE_FLEE_DURATION = 2.0
const TILE_SIZE = 16
const REGULAR_SPEED = 85
const SLOWER_SPEED = 60

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var movement_speed := REGULAR_SPEED
var fleeing := false
var vulnerable := false

func _ready():
	add_to_group("ghosts")
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 1.0
	match ghost_name:
		"blinky":
			add_to_group("blinky")
			$Sprite2D.modulate = Color("red")
		"pinky":
			$Sprite2D.modulate = Color("pink")
		"inky":
			$Sprite2D.modulate = Color("blue")
		"clide":
			$Sprite2D.modulate = Color("orange")

func set_movement_target(player_position: Vector2, player_facing: Vector2):
	if fleeing:
		flee(player_position)
	else:
		match ghost_name:
			"blinky": chase(player_position)
			"pinky": cut_off(player_position, player_facing)
			"inky": inky_move(player_position, player_facing)
			"clide": clide_move(player_position)
			_: chase(player_position)

func chase(player_position: Vector2):
	navigate_or_warp_to(player_position)

## Special logic is needed to make the ghosts aware of the warp tunnels
func navigate_or_warp_to(position: Vector2):
	var distance_direct = (position - global_position).length()

	var left_warp = get_tree().get_first_node_in_group("left_warp")
	var right_warp = get_tree().get_first_node_in_group("right_warp")

	var distance_via_left_warp = get_distance_to_target_via_warp(left_warp, right_warp, position)
	var distance_via_right_warp = get_distance_to_target_via_warp(right_warp, left_warp, position)

	var shortest = min(distance_direct, distance_via_left_warp, distance_via_right_warp)

	if distance_direct == shortest:
		navigation_agent.target_position = position
	elif distance_via_left_warp == shortest:
		navigation_agent.target_position = left_warp.global_position
	else:
		navigation_agent.target_position = right_warp.global_position
	
func get_distance_to_target_via_warp(
	entry_warp: Area2D,
	exit_warp: Area2D,
	target_position: Vector2
) -> float:
	var distance_to_warp = (entry_warp.global_position - global_position).length()
	var warp_to_target_distance = (target_position - exit_warp.global_position).length()
	return distance_to_warp + warp_to_target_distance

func cut_off(player_position: Vector2, player_facing: Vector2):
	var target_position = player_position + (player_facing * TILE_SIZE * 4)
	navigate_or_warp_to(target_position)

## Draw a line from Blinky’s position to the cell two tiles in front of Pac-Man,
## then double the length of the line. That is Inky’s target position.
func inky_move(player_position: Vector2, player_facing: Vector2):
	var blinky = get_tree().get_first_node_in_group("blinky")
	if not blinky: chase(player_position)
	
	var position_in_front_of_player = player_position + (player_facing * TILE_SIZE * 2)
	var target_position = (position_in_front_of_player - blinky.global_position) * 2
	navigate_or_warp_to(to_global(target_position))

## Orange ghost “Clyde” will target Pac-Man directly,
## but will scatter whenever he gets within an 8 tile radius of Pac-Man.
func clide_move(player_position: Vector2):
	if (player_position - global_position).length() < TILE_SIZE * 8:
		flee_with_timeout(CLIDE_FLEE_DURATION)
	else:
		chase(player_position)

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

## Scatter mode is a combo of fleeing + vulnerable
func trigger_scatter_mode():
	vulnerable = true
	$ScaredSprite2D.visible = true

	movement_speed = SLOWER_SPEED
	await flee_with_timeout(SCATTER_DURATION)
	movement_speed = REGULAR_SPEED

	vulnerable = false
	$ScaredSprite2D.visible = false

func flee_with_timeout(duration: float):
	fleeing = true
	await get_tree().create_timer(duration).timeout
	fleeing = false

## When a ghost is eaten, it should turn into eyes, return to the pen,
## and respawn as a regular ghost
func eaten():
	queue_free()
