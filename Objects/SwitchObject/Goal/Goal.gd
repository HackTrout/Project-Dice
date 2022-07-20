extends SwitchObject
class_name Goal

# PROPERTIES --------------------------------------------------------------------------------------

export(Texture) var texture
export(String) var nextScene = ""

export(int) var turnAmount : int = 1

signal goalGained

# METHODS -----------------------------------------------------------------------------------------


func _ready():
	if enabled:
		# Enable collision
		$SwitchHitbox/Shape.set_deferred("disabled", false)
		$AnimationPlayer.play("Active", -1, 2.0)
	else:
		# Disable collision
		$SwitchHitbox/Shape.set_deferred("disabled", true)
		$AnimationPlayer.play("Inactive", -1, 0.25)
	
	$SwitchSprite.enabled = enabled
	$SwitchSprite.on_texture = texture
	$SwitchSprite.update_texture()


func enable() -> void:
	
	# CALLED TO ENABLE OBJECT
	.enable()
	
	# Animate
	$AnimationPlayer.play("Active", -1, 2.0)
	
	# Enable collision
	$SwitchHitbox/Shape.set_deferred("disabled", false)


func disable() -> void:
	
	# CALLED TO DISABLE OBJECT
	.disable()
	
	# Next scene
	if nextScene != "":
		var goAhead = true
		for goal in get_tree().get_nodes_in_group("goal"):
			if goal.enabled == true:
				goAhead = false
				break
		
		if goAhead:
			get_tree().call_group("PostProcess", "change_scene", nextScene)
			return
	
	# Animate
	$AnimationPlayer.play("Inactive", -1, 0.25)
	
	# Disable collision
	$SwitchHitbox/Shape.set_deferred("disabled", true)
	emit_signal("goalGained", turnAmount)
