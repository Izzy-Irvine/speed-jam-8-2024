extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -1000.0


func _physics_process(delta: float) -> void:
	if not Globals.game_running:
		return
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
				var finish_screen = get_node("/root/Level/FinishScreen")
				if Globals.game_running:
					Globals.final_time = Globals.time_elapsed
					print("ended at: ", Globals.time_elapsed)
					var time_text = finish_screen.get_node("FinalTimeText")
					time_text.text = "Final time: %.3f" % (Globals.time_elapsed)
				finish_screen.visible = true
				Globals.game_running = false
				

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
	
	if position.y > 2000 and Globals.game_running:
		var game_over_screen = get_node("/root/Level/GameOverScreen")
		game_over_screen.visible = true
		Globals.game_running = false

	move_and_slide()
	

func get_state():
	return {
		"transform": transform,
		"velocity": velocity
	}

func set_state(state: Dictionary):
	transform = state["transform"]
	velocity = state["velocity"]
