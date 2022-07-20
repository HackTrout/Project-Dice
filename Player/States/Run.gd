extends State

# PROPERTIES --------------------------------------------------------------------------------------


# METHODS -----------------------------------------------------------------------------------------


func enter_state() -> void:
	
	# Inherit
	.enter_state()
	
	# EXECUTED WHEN FIRST SWITCHING TO A NEW STATE
	
	# Animate
	animator.play("Run", -1, 2.0)


func process_state(delta):
	
	# Inherit
	.process_state(delta)
	
	# RUN STATE
	
	# Get direction animal wants to move in
	var axis : Vector2 = player.get_axis()
	
	# Accelerate animal's velocity
	
	if axis != Vector2.ZERO:
		var surfaceTangent : Vector2 = player.get_surface_normal().rotated((PI / 2.0) * axis.x) # Direction of surface's slope in player's direction
		var dot : float = surfaceTangent.dot(Vector2.RIGHT)
		var slope : float = clamp(abs(dot) - player.runSurface, 0.0, 1.0) / (1.0 - player.runSurface) # How steep the slope is
		if sign(surfaceTangent.y) == 1: slope = 1 # If travelling downslope, go full speed
		player.velocity += surfaceTangent * (player.speed * slope)
	
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
		animator.play("Run")
	
	# Sounds
	if $Timer.is_stopped():
		SoundPlayer.play("walk")
		$Timer.start()
	
	# TRANSITIONS
	
	# -> Idle
	
	if axis == Vector2.ZERO:
		exit_state(State.IDLE)
	
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
		State.FALL:
			pass
	
	# Change state
	var state : State = get_parent().get_child(newState)
	player.currentState = state
	animator.stop()
	state.enter_state()
