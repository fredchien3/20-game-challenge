extends Node2D

signal game_over(winning_bean)

## How long to wait after explosion before cycling active bean
const BEAN_CYCLE_DELAY := 1.0

@export var terrain: StaticBody2D
@export var camera: Camera2D
@export var ExplosionScene: PackedScene

var game_active = true
var active_bean: CharacterBody2D
var active_bean_index := 0
var beans: Array[Node]


func _ready() -> void:
	Engine.time_scale = 1.0
	beans = get_tree().get_nodes_in_group("beans")

	beans.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)

	active_bean = beans[active_bean_index]
	active_bean.set_active(true)
	camera.global_position = active_bean.global_position

	# Bind weapon spawns
	for bean in beans:
		bean.grenade_thrown.connect(_on_bean_grenade_thrown)
		bean.bazooka_shot.connect(_on_bean_bazooka_shot)
		bean.died.connect(_on_bean_died)
		bean.exploded.connect(_on_explosion)


func _physics_process(_delta: float) -> void:
	if not game_active:
		return

	if len(beans) == 1:
		game_over.emit(beans[0])
		Engine.time_scale = 0.25
		game_active = false
	if len(beans) == 0:
		game_over.emit(null)
		Engine.time_scale = 0.25
		game_active = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_p"):
		cycle_active_bean()


func reload():
	get_tree().reload_current_scene()


## Cycles through the beans array, skipping past any beans that have been freed
func cycle_active_bean():
	if len(beans) == 0:
		return

	if active_bean:
		active_bean.set_active(false)

	active_bean_index += 1
	if active_bean_index >= len(beans):
		active_bean_index = 0

	if beans[active_bean_index]:
		active_bean = beans[active_bean_index]
		active_bean.set_active(true)
		camera.global_position = active_bean.global_position
	else:
		cycle_active_bean()


## bean died but hasn't yet exploded.
func _on_bean_died(bean: CharacterBody2D):
	beans.erase(bean)
	if active_bean == bean:
		await get_tree().create_timer(2.5).timeout
		active_bean_index -= 1
		cycle_active_bean()


func _on_bean_grenade_thrown(grenade: RigidBody2D) -> void:
	add_child(grenade)
	grenade.exploded.connect(_on_weapon_explosion)


func _on_bean_bazooka_shot(bazooka: RigidBody2D) -> void:
	add_child(bazooka)
	bazooka.exploded.connect(_on_weapon_explosion)


## Calls _on_explosion handler, and initiates a delayed bean cycle
func _on_weapon_explosion(pos, radius):
	_on_explosion(pos, radius)
	await get_tree().create_timer(BEAN_CYCLE_DELAY).timeout
	cycle_active_bean()


func _on_explosion(pos, radius):
	var explosion = ExplosionScene.instantiate()
	explosion.global_position = pos
	# Explosion will queue_free itself after animation completes
	add_child(explosion)

	terrain.cutout_hole(pos, radius)

	# Apply damage and knockback to any beans in the area of the explosion
	var explosion_area := Area2D.new()
	explosion_area.global_position = pos
	var collision_shape = CollisionShape2D.new()
	explosion_area.add_child(collision_shape)
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = radius
	# TODO: programmatically set "beans" collision layer
	explosion_area.collision_mask = 2
	explosion_area.body_entered.connect(_on_explosion_area_body_entered.bind(pos, radius))
	call_deferred("add_child", explosion_area)
	await get_tree().create_timer(0.1).timeout
	explosion_area.queue_free()


func _on_explosion_area_body_entered(body, pos, radius):
	if body.is_in_group("beans"):
		body.receive_damage_and_knockback(pos, radius)


func _on_out_of_bounds_body_entered(body: Node2D) -> void:
	if body.is_in_group("beans"):
		body.die_from_oob()
