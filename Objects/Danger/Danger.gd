extends LevelObject
class_name Danger

# PROPERTIES --------------------------------------------------------------------------------------



# METHODS -----------------------------------------------------------------------------------------



func _on_body_entered(body):
	
	# Kill Player
	if body is Player:
		body.currentState.exit_state(body.currentState.State.DIE)
