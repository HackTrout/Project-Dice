extends State

# PROPERTIES --------------------------------------------------------------------------------------


# METHODS -----------------------------------------------------------------------------------------


func enter_state() -> void:
	
	# Inherit
	.enter_state()
	
	# EXECUTED WHEN FIRST SWITCHING TO A NEW STATE
	
	# Animate
	animator.play("Idle")


func process_state(delta):
	
	# Inherit
	.process_state(delta)
	
	# IDLE STATE
	
	# Apply friction
	player.velocity *= player.groundFriction
	
	# Update grounded buffer
	var surfaceCheck : int = player.check_surface()
	if surfaceCheck != 0:
		Input.action_press("grounded")
	else:
		Input.action_release("grounded")
	
	# Stick to floor
	if surfaceCheck == 0 && InputManager.check_action("grounded"):
		player.velocity.y += player.gravity
	
	# Interact
	if Input.is_action_just_pressed("interact"):
		
		# Interact with objects
		player.interact()
		
		# Play animation
		animator.play("Interact", -1, 2.0)
	
	# Play idle if no animation is playing
	if !animator.is_playing():
		animator.play("Idle")
	
	# TRANSITIONS
	
	# -> Run
	
	if player.get_axis() != Vector2.ZERO:
		exit_state(State.RUN)
	
	# -> Jump
	
	if InputManager.check_action("jump"):
		exit_state(State.JUMP)
	
	# -> Slide
	
	if surfaceCheck == 1:
		exit_state(State.SLIDE)
	
	# -> Fall
	
	if !InputManager.check_action("grounded"):
		exit_state(State.FALL)


func exit_state(newState : int) -> void:
	
	# Inherit
	.exit_state(newState)
	
	# TRANSITION BETWEEN PLAYER'S CURRENT STATE AND "newState", PERFORMING ANY SPECIFIC ACTIONS
	
	# Specific transitions
	match newState:
		State.RUN:
			pass
		State.FALL:
			pass
	
	# Change state
	var state : State = get_parent().get_child(newState)
	player.currentState = state
	animator.stop()
	state.enter_state()
