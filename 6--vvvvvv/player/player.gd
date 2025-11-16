extends CharacterBody2D

const SPEED = 80.0

@onready var gravity_multiplier = 0.4
@onready var spawn_position = global_position
@onready var alive = true


func get_modified_gravity():
	return get_gravity() * gravity_multiplier
	
func flip_gravity():
	gravity_multiplier = -gravity_multiplier
	up_direction = Vector2.DOWN if up_direction == Vector2.UP else Vector2.UP
	var current_scale = $AnimationPlayer.scale
	$AnimationPlayer.scale = Vector2(1, -current_scale.y)
	
func _physics_process(delta: float) -> void:
	if not alive: return

	velocity += get_modified_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		flip_gravity()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		var current_scale = $AnimationPlayer.scale
		$AnimationPlayer.scale = Vector2(direction * 1, current_scale.y)
		
		if is_on_floor():
			$AnimationPlayer.animation = "running"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			$AnimationPlayer.animation = "idle"
	
	if not is_on_floor():
		$AnimationPlayer.animation = "falling"

	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	die()

func die():
	print("ribbit... I'm dead")
	alive = false
	await get_tree().create_timer(2).timeout
	respawn()
	
func respawn():
	global_position = spawn_position
	alive = true
