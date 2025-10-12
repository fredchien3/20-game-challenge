extends CharacterBody2D

@export_enum("blinky", "pinky", "inky", "clide") var ghost_name: String

const VULNERABLE_DURATION = 5.0
const CLIDE_FLEE_DURATION = 1.0
const RESPAWN_DELAY = 1.0
const TILE_SIZE = 16

enum Status { NORMAL, FLEEING, VULNERABLE_FLEEING, RESPAWNING }

const status_speeds = {
	Status.NORMAL: 85.0,
	Status.FLEEING: 85.0,
	Status.VULNERABLE_FLEEING: 45.0,
	Status.RESPAWNING: 135.0,
}

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var spawn_point = Vector2(224, 288)

var current_status = Status.NORMAL

func _ready():
	add_to_group("ghosts")
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 1.0
	
	$BodySprite.animation = ghost_name
	$BodySprite.play()
	$EyesSprite.play()
	
	if ghost_name == "blinky":
		add_to_group("blinky")

func set_movement_target(player_position: Vector2, player_facing: Vector2):
	match current_status:
		Status.NORMAL:
			match ghost_name:
				"blinky": chase(player_position)
				"pinky": cut_off(player_position, player_facing)
				"inky": inky_move(player_position, player_facing)
				"clide": clide_move(player_position)
				_: chase(player_position)
		Status.FLEEING:
			flee(player_position)
		Status.VULNERABLE_FLEEING:
			flee(player_position)
		Status.RESPAWNING:
			navigate_or_warp_to(spawn_point)

	update_eyes()
			
func update_eyes():
	var next_pos = navigation_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	direction = Vector2(round(direction.x), round(direction.y))
	match direction:
		Vector2.UP:
			$EyesSprite.animation = "up"
		Vector2.DOWN:
			$EyesSprite.animation = "down"
		Vector2.LEFT:
			$EyesSprite.animation = "left"
		Vector2.RIGHT:
			$EyesSprite.animation = "right"

func chase(player_position: Vector2):
	navigate_or_warp_to(player_position)

## Special logic is needed to make the ghosts aware of the warp tunnels
func navigate_or_warp_to(pos: Vector2):
	var distance_direct = (pos - global_position).length()

	var left_warp = get_tree().get_first_node_in_group("left_warp")
	var right_warp = get_tree().get_first_node_in_group("right_warp")

	var distance_via_left_warp = get_distance_to_target_via_warp(left_warp, right_warp, pos)
	var distance_via_right_warp = get_distance_to_target_via_warp(right_warp, left_warp, pos)

	var shortest = min(distance_direct, distance_via_left_warp, distance_via_right_warp)

	if distance_direct == shortest:
		navigation_agent.target_position = pos
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
	if not blinky: return chase(player_position)

	var position_in_front_of_player = player_position + (player_facing * TILE_SIZE * 2)
	var target_position = (position_in_front_of_player - blinky.global_position) * 2
	navigate_or_warp_to(to_global(target_position))

## Orange ghost “Clyde” will target Pac-Man directly,
## but will scatter whenever he gets within an 8 tile radius of Pac-Man.
func clide_move(player_position: Vector2):
	if (player_position - global_position).length() < TILE_SIZE * 8:
		# Guard clauses to not interfere with respawning behavior
		if current_status == Status.NORMAL:
			current_status = Status.FLEEING
			
		await get_tree().create_timer(CLIDE_FLEE_DURATION).timeout
		
		if current_status == Status.FLEEING:
			current_status = Status.NORMAL
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

	velocity = current_agent_position.direction_to(next_path_position) \
		* status_speeds[current_status]

	move_and_slide()

func trigger_scatter_mode():
	if current_status != Status.RESPAWNING:
		$BodySprite.animation = "scared"
		$EyesSprite.visible = false
		current_status = Status.VULNERABLE_FLEEING

	await get_tree().create_timer(VULNERABLE_DURATION / 2).timeout
	
	if current_status == Status.VULNERABLE_FLEEING:
		$BodySprite.animation = "scared_blinking"

	await get_tree().create_timer(VULNERABLE_DURATION / 2).timeout

	if current_status != Status.RESPAWNING:
		current_status = Status.NORMAL
		$BodySprite.animation = ghost_name
		$EyesSprite.visible = true


func is_vulnerable() -> bool:
	return current_status == Status.VULNERABLE_FLEEING \
		or current_status == Status.RESPAWNING

## When a ghost is eaten, it should turn into eyes, return to the pen,
## and respawn as a regular ghost
func eaten():
	$BodySprite.visible = false
	$EyesSprite.visible = true
	
	current_status = Status.RESPAWNING
	# To prevent getting stuck on corners (I think due to higher movement speed)
	$CollisionShape2D.scale = Vector2(0.1, 0.1)
	
func respawn():
	await get_tree().create_timer(RESPAWN_DELAY).timeout
	$BodySprite.visible = true
	$EyesSprite.visible = true
	$BodySprite.animation = ghost_name
	current_status = Status.NORMAL
	$CollisionShape2D.scale = Vector2(1, 1)
	
