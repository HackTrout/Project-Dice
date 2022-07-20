extends State

# PROPERTIES --------------------------------------------------------------------------------------


# METHODS -----------------------------------------------------------------------------------------


func enter_state() -> void:
	
	# Inherit
	.enter_state()
	
	# EXECUTED WHEN FIRST SWITCHING TO A NEW STATE
	
	# Toggle grounded buffer off
	InputManager.toggle_action("grounded")
	
	# Animate
	animator.play("Fall", -1, 2.0)


func process_state(delta):
	
	# Inherit
	.process_state(delta)
	
	# FALL STATE
	
	# Move in mid air
	var axis : Vector2 = player.get_axis()
	player.velocity += axis * player.airSpeed
	
	# Apply gravity
	player.velocity.y += player.gravity
	
	# Apply air friction
	player.velocity.x *= player.airFriction
	
	# Apply wall friction if near wall and moving into wall
	if player.can_wall_jump() && (axis.x == -player.wallJumpNormal.x):
		player.velocity.y *= player.groundFriction
	
	# TRANSITIONS
	var surfaceCheck : int = player.check_surface()
	
	# -> Slide
	
	if surfaceCheck == 1:
		exit_state(State.SLIDE)
	
	# -> Idle
	
	if surfaceCheck == 2:
		exit_state(State.IDLE)
	
	# -> Jump
	
	if player.can_wall_jump() && InputManager.check_action("jump"):
		exit_state(State.WALL_JUMP)


func exit_state(newState : int) -> void:
	
	# Inherit
	.exit_state(newState)
	
	# TRANSITION BETWEEN PLAYER'S CURRENT STATE AND "newState", PERFORMING ANY SPECIFIC ACTIONS
	
	# Specific transitions
	match newState:
		State.IDLE:
			pass
	
	# Change state
	var state : State = get_parent().get_child(newState)
	player.currentState = state
	state.enter_state()
	
	# Sounds
	SoundPlayer.play("land")
