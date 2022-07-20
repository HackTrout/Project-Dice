extends State

# PROPERTIES --------------------------------------------------------------------------------------

var jumpButtonReleased : bool = false

# METHODS -----------------------------------------------------------------------------------------


func enter_state() -> void:
	
	# Inherit
	.enter_state()
	
	# EXECUTED WHEN FIRST SWITCHING TO A NEW STATE
	
	# Apply jump speed
	player.velocity += player.jumpSpeed * player.standardJumpNormal
	jumpButtonReleased = false
	
	# Toggle input buffer for jumping
	InputManager.toggle_action("jump")
	
	# Reset Jump Normal
	player.jumpNormal = player.standardJumpNormal
	
	# Animate
	animator.play("Jump", -1, 2.0)
	
	# Sounds
	SoundPlayer.play("jump")


func process_state(delta):
	
	# Inherit
	.process_state(delta)
	
	# JUMP STATE
	
	# Move in mid air
	player.velocity += player.get_axis() * player.airSpeed
	
	# Apply gravity
	player.velocity.y += player.gravity
	
	# Apply air friction
	player.velocity.x *= player.airFriction
	
	# Minimum jump speed
	if Input.is_action_just_released("jump") && !jumpButtonReleased:
		player.velocity.y = max(player.velocity.y, -player.minJumpSpeed)
		jumpButtonReleased = true
	
	# TRANSITIONS
	
	# -> Fall
	
	if player.velocity.y >= 0.0:
		exit_state(State.FALL)
	
	# -> Slide
	
	var surfaceCheck : int = player.check_surface()
	if surfaceCheck == 1 && !InputManager.check_action("grounded"):
		exit_state(State.SLIDE)
		
		# Sounds
		SoundPlayer.play("land")


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
	state.enter_state()
