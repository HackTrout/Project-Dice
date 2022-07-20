extends SwitchObject
class_name BarrierBlock

# PROPERTIES --------------------------------------------------------------------------------------



# METHODS -----------------------------------------------------------------------------------------


func _ready() -> void:
	if enabled:
		$Collider/Shape.set_deferred("disabled", false)
	else:
		$Collider/Shape.set_deferred("disabled", true)


func enable() -> void:
	
	# CALLED TO ENABLE OBJECT
	.enable()
	
	# Enable Collision
	$Collider/Shape.set_deferred("disabled", false)


func disable() -> void:
	
	# CALLED TO DISABLE OBJECT
	.disable()
	
	# Disable Collision
	$Collider/Shape.set_deferred("disabled", true)
