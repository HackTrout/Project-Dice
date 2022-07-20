extends State

# PROPERTIES --------------------------------------------------------------------------------------


# METHODS -----------------------------------------------------------------------------------------


func enter_state() -> void:
	
	# Inherit
	.enter_state()
	
	# EXECUTED WHEN FIRST SWITCHING TO A NEW STATE
	
	# Animate
	animator.play("Slide", -1, 2.0)


func process_state(delta):
	
	# Inherit
	.process_state(delta)
	
	# SLIDE STATE
	
	# Get slide direction
	var surfaceNormal : Vector2 = player.get_surface_normal()
	var surfaceTangent : Vector2 = surfaceNormal.rotated((PI / 2.0)) # Direction of surface's slope in player's direction
	if surfaceTangent.y < 0.0:
		surfaceTangent = surfaceNormal.rotated(-(PI / 2.0))
	
	# Apply gravity
	player.velocity += player.gravity * surfaceTangent
	
	# Apply friction
	player.velocity *= player.slideFriction
	
	# Update grounded buffer
	var surfaceCheck : int = player.check_surface()
	if surfaceCheck != 0:
		Input.action_press("grounded")
	else:
		Input.action_release("grounded")
	
	# Sounds
	if $Timer.is_stopped():
		SoundPlayer.play("walk")
		$Timer.start()
	
	# TRANSITIONS
	
	# -> Run
	
	if surfaceCheck == 2:
		exit_state(State.RUN)
	
	# -> Wall Jump
	
	if InputManager.check_action("jump"):
		player.slideJumpNormal.x = abs(player.slideJumpNormal.x) * sign(surfaceNormal.x)
		exit_state(State.SLIDE_JUMP)
	
	# -> Fall
	
	if !InputManager.check_action("grounded"):
		exit_state(State.FALL)


func exit_state(newState : int) -> void:
	
	# Inherit
	.exit_state(newState)
	
	# TRANSITION BETWEEN PLAYER'S CURRENT STATE AND "newState", PERFORMING ANY SPECIFIC ACTIONS
	
	# Specific transitions
	match newState:
		State.FALL:
			pass
	
	# Change state
	var state : State = get_parent().get_child(newState)
	player.currentState = state
	animator.stop()
	state.enter_state()
