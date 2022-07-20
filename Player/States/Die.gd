extends State

# PROPERTIES --------------------------------------------------------------------------------------


# METHODS -----------------------------------------------------------------------------------------


func enter_state() -> void:
	
	# Inherit
	.enter_state()
	
	# EXECUTED WHEN FIRST SWITCHING TO A NEW STATE
	
	# Create particles
	get_tree().call_group("FX", "create_particle", "bone", player.global_position)
	get_tree().call_group("FX", "create_particle", "skull", player.global_position)
	
	# Sounds
	SoundPlayer.play("die")
	
	# Change scene
	get_tree().call_group("PostProcess", "reload")


func process_state(delta):
	
	# Inherit
	.process_state(delta)
	
	# DIE STATE
	player.queue_free()
