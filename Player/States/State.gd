extends Node
class_name State


# PROPERTIES --------------------------------------------------------------------------------------


enum State {IDLE, RUN, SLIDE, JUMP, WALL_JUMP, SLIDE_JUMP, FALL, DIE}
onready var player = get_parent().get_parent()
onready var animator : AnimationPlayer = player.get_node("PlayerBody/AnimationPlayer")


# METHODS -----------------------------------------------------------------------------------------


func enter_state() -> void:
	
	# EXECUTED WHEN FIRST SWITCHING TO A NEW STATE
	
	pass


func process_state(delta):
	
	# CODE TO BE EXECUTED EVERY PHYSICS FRAME IF THIS STATE IS ACTIVE
	
	pass


func exit_state(newState : int) -> void:
	
	# TRANSITION BETWEEN PLAYER'S CURRENT STATE AND "newState", PERFORMING ANY SPECIFIC ACTIONS
	
	pass
