extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -1000.0


func _physics_process(delta: float) -> void:
	if velocity.x:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("idle")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.play("jump")
	else:
		for i in get_slide_collision_count():
			if get_slide_collision(i).get_collider().name == "EndPlatform":
				print("ended at: ", Globals.time_elapsed)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

func get_state():
	return {
		"transform": transform,
		"velocity": velocity
	}

func set_state(state: Dictionary):
	transform = state["transform"]
	velocity = state["velocity"]
