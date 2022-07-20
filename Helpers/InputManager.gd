extends Node

# VARIABLES

enum Action {IS_PRESSED, SECONDS_ELAPSED, MAX_SECONDS, INPUT_TYPE}
enum InputType {PRESSED, JUST_PRESSED, JUST_RELEASED, NO_INPUT}
var actionInfo = {
	# ACTION_NAME 	: [IS_PRESSED, SECONDS_ELAPSED, MAX_SECONDS, INPUT_TYPE]
	"jump" 			: [false, 0.0, 0.1, InputType.JUST_PRESSED],
	"grounded"		: [false, 0.0, 0.05, InputType.PRESSED]
}

# FUNCTIONS

func _process(delta):
	
	# Update actions
	
	for action in actionInfo.keys():
		
		var info : Array = actionInfo[action]
		
		# Check for new input
		var isPressed : bool = false
		match info[Action.INPUT_TYPE]:
			InputType.PRESSED: 			isPressed = Input.is_action_pressed(action)
			InputType.JUST_PRESSED: 	isPressed = Input.is_action_just_pressed(action)
			InputType.JUST_RELEASED: 	isPressed = Input.is_action_just_released(action)
			InputType.NO_INPUT:			isPressed = false
		
		# If new input is found, update buffer and info and move onto the next action
		if isPressed:
			info[Action.IS_PRESSED] = true
			info[Action.SECONDS_ELAPSED] = 0.0
			continue
		
		# If action is thought to be pressed
		if info[Action.IS_PRESSED]:
			
			var timeSince : float = info[Action.SECONDS_ELAPSED]
			if timeSince > info[Action.MAX_SECONDS]:
				info[Action.IS_PRESSED] = false
			else:
				info[Action.SECONDS_ELAPSED] += delta


func action_exists(action : String) -> bool:
	
	# RETURNS WHETHER THERE IS AN ENTRY FOR A GIVEN ACTION
	
	if !actionInfo.keys().has(action):
		print("ERROR: Action not found.")
		return false
	
	return true


func check_action(action : String) -> bool:
	
	# RETURNS TRUE OR FALSE WHETHER A GIVEN ACTION SHOULD BE PERFORMED
	
	# Ignore if action isn't in dictionary
	if !action_exists(action): return false
	
	# Return bool otherwise
	return actionInfo[action][Action.IS_PRESSED]


func toggle_action(action : String, new_val : bool = false) -> void:
	
	# ACKNOWLEDGE THAT THE ACTION HAS BEEN PERFORMED AND DISABLE IT SO REPEATS AREN'T PERFORMED
	# OR MANUALLY SET IT TO TRUE
	
	# Ignore if action isn't in dictionary
	if !action_exists(action): return
	
	# Disable bool
	actionInfo[action][Action.IS_PRESSED] = new_val
