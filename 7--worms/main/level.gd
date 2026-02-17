extends Node2D

## How long to wait after explosion before cycling active worm
const WORM_CYCLE_DELAY := 1.0

@export var terrain: StaticBody2D
@export var camera: Camera2D

var active_worm: CharacterBody2D
var active_worm_index := 0
var worms: Array[Node]


func _ready() -> void:
	worms = get_tree().get_nodes_in_group("worms")
	worms.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)

	active_worm = worms[active_worm_index]
	active_worm.set_active(true)
	camera.global_position = active_worm.global_position

	# Bind weapon spawns
	for worm in worms:
		worm.grenade_thrown.connect(_on_worm_grenade_thrown)
		worm.bazooka_shot.connect(_on_worm_bazooka_shot)
		worm.died.connect(_on_worm_died)
		worm.exploded.connect(_on_explosion)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_p"):
		cycle_active_worm()


## Cycles through the worms array, skipping past any worms that have been freed
func cycle_active_worm():
	if len(worms) == 0:
		return

	if active_worm:
		active_worm.set_active(false)

	active_worm_index += 1
	if active_worm_index >= len(worms):
		active_worm_index = 0

	if worms[active_worm_index]:
		active_worm = worms[active_worm_index]
		active_worm.set_active(true)
		camera.global_position = active_worm.global_position
	else:
		cycle_active_worm()


## Worm died but hasn't yet exploded.
func _on_worm_died(worm: CharacterBody2D):
	worms.remove_at(worms.find(worm))
	if active_worm == worm:
		await get_tree().create_timer(2.5).timeout
		active_worm_index -= 1
		cycle_active_worm()


func _on_worm_grenade_thrown(grenade: RigidBody2D) -> void:
	add_child(grenade)
	grenade.exploded.connect(_on_weapon_explosion)


func _on_worm_bazooka_shot(bazooka: RigidBody2D) -> void:
	add_child(bazooka)
	bazooka.exploded.connect(_on_weapon_explosion)


## Calls _on_explosion handler, and adds a delayed worm cycle
func _on_weapon_explosion(pos, radius):
	_on_explosion(pos, radius)
	await get_tree().create_timer(WORM_CYCLE_DELAY).timeout
	cycle_active_worm()


func _on_explosion(pos, radius):
	terrain.cutout_hole(pos, radius)

	# Apply damage and knockback to any worms in the area of the explosion
	var explosion_area := Area2D.new()
	explosion_area.global_position = pos
	var collision_shape = CollisionShape2D.new()
	explosion_area.add_child(collision_shape)
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = radius
	# TODO: programmatically set "worms" collision layer
	explosion_area.collision_mask = 2
	explosion_area.body_entered.connect(_on_explosion_area_body_entered.bind(pos, radius))
	call_deferred("add_child", explosion_area)
	await get_tree().create_timer(0.1).timeout
	explosion_area.queue_free()


func _on_explosion_area_body_entered(body, pos, radius):
	if body.is_in_group("worms"):
		body.receive_damage_and_knockback(pos, radius)
