extends KinematicBody2D
class_name Player


# PROPERTIES --------------------------------------------------------------------------------------

# FSM
onready var currentState : State = $States/Idle

# Motion
var velocity := Vector2.ZERO
export(float) var speed := 28.0
export(float) var airSpeed := 16.0
export(float) var gravity := 18.0

# Friction
export(float, 0.0, 1.0, 0.01) var groundFriction := 0.8
export(float, 0.0, 1.0, 0.01) var airFriction := 0.85
export(float, 0.0, 1.0, 0.01) var slideFriction := 0.9

# Jumping
var jumpNormal := Vector2.UP
var standardJumpNormal := Vector2.UP
export(float) var jumpSpeed := 400.0
export(float) var minJumpSpeed := 240.0

# Wall Jumping
export(float) var wallJumpSpeed := 600.0
export(float) var minWallJumpSpeed := 540.0
onready var wallJumpNormal := Vector2.RIGHT.rotated(deg2rad(-60))

# Slide Jumping
export(float) var slideJumpSpeed := 540.0
export(float) var minSlideJumpSpeed := 480.0
onready var slideJumpNormal := Vector2.RIGHT.rotated(deg2rad(-80))

# Dot Products for determing surfaces
var runSurface : float = 0.9			# Compared against Vector2.UP
var wallSurface : float = 0.1			# Compared against Vector2.UP

# Interacting
var nearbySwitches : Array = []
var nearbyObjects : Array = []

# Carrying
var carrying : bool = false
var inventory : CarryObject = null
var objectParent = null


# METHODS -----------------------------------------------------------------------------------------


func _physics_process(delta):
	
	# FINITE STATE MACHINE
	currentState.process_state(delta)
	
	# MOVING THE PLAYER
	
	# Move
	velocity = move_and_slide(velocity, Vector2.UP, true, 4, .92)
	
	# Rotate Player
	rotation = -get_parent().get_parent().rotation


func get_axis() -> Vector2:
	
	# RETURN NORMALIZED VECTOR POINTING IN DIRECTION ANIMAL WANTS TO MOVE IN
	
	var axis := Vector2.ZERO
	
	# Receive player input
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	# Output normalized vector
	return axis.normalized()


var surfaceNormal := Vector2.ZERO		# Saves the last calculated surface normal
func check_surface() -> int:
	
	# USE RAYCASTS TO DETERMINE WHETHER PLAYER IS ON A SLIDEABLE SURFACE
	
	# Iterate through all rays
	for ray in $FloorRays.get_children():
		
		# Force update
		ray.force_raycast_update()
		
		if ray.is_colliding():
			# Get surface normal and check if it can be slid on
			surfaceNormal = ray.get_collision_normal()
			if can_slide_on(surfaceNormal):
				return 1
			
			if can_run_on(surfaceNormal):
				return 2
	
	return 0


func get_surface_normal() -> Vector2:
	check_surface()		# Force recalculation
	return surfaceNormal


func is_floor_flat(n : Vector2) -> bool:
	return abs(n.dot(Vector2.UP)) > runSurface


func can_slide_on(n : Vector2) -> bool:
	var dot = abs(n.dot(Vector2.UP))
	return dot < runSurface && dot > 0.0


func can_run_on(n : Vector2) -> bool:
	return abs(n.dot(Vector2.UP)) > runSurface


func can_wall_jump() -> bool:
	
	# USE RAYCASTS TO DETERMINE WHETHER PLAYER IS NEAR A WALL
	
	# Iterate through all rays
	for ray in $WallRays.get_children():
		
		# Force update
		ray.force_raycast_update()
		
		if ray.is_colliding():
			# Get surface normal and check if it can be slid on
			var wallNormal = ray.get_collision_normal()
			if abs(wallNormal.dot(Vector2.UP)) < wallSurface:
				wallJumpNormal.x = abs(wallJumpNormal.x) * sign(wallNormal.x)
				return true
	
	return false


func interact() -> void:
	
	# Carrying
	if carrying:
		# Drop
		objectParent.add_child(inventory)
		inventory.global_position = global_position
		$PlayerBody/Anchor/Item.visible = false
		carrying = false
	else:
		#Pick up object
		if !nearbyObjects.empty():
			inventory = nearbyObjects[0]
			objectParent = inventory.get_parent()
			objectParent.remove_child(inventory)
			$PlayerBody/Anchor/Item.texture = inventory.texture
			$PlayerBody/Anchor/Item.visible = true
			carrying = true
	
	
	# Interact with nearby switch
	if !nearbySwitches.empty():
		var switch = nearbySwitches[0]
		switch.toggle()
		
		# Sounds
		SoundPlayer.play("interact")
		
		return


func _on_Hitbox_area_entered(area):
	
	# Achieve goal
	if area.get_parent() is Goal:
		area.get_parent().toggle()
		
		# Sounds
		SoundPlayer.play("finish_level")
	
	# Activate sign
	if area.get_parent() is Sign:
		area.get_parent().enable()
	
	# Add nearby switch to list
	if area.get_parent() is SwitchObject:
		if !nearbySwitches.has(area.get_parent()) && !area.get_parent().ignorePlayer:
			nearbySwitches.append(area.get_parent())
	
	# Add carry object to list
	if area.get_parent() is CarryObject:
		if !nearbyObjects.has(area.get_parent()):
			nearbyObjects.append(area.get_parent())
	


func _on_Hitbox_area_exited(area):
	
	# Decativate sign
	if area.get_parent() is Sign:
		area.get_parent().disable()
	
	# Remove switch from list
	if area.get_parent() is SwitchObject:
		if nearbySwitches.has(area.get_parent()):
			nearbySwitches.remove(nearbySwitches.find(area.get_parent()))
	
	# Remove carry object from list
	if area.get_parent() is CarryObject:
		if nearbyObjects.has(area.get_parent()):
			nearbyObjects.remove(nearbyObjects.find(area.get_parent()))
