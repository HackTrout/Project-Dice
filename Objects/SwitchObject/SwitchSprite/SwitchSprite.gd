extends Sprite
class_name SwitchSprite

# PROPERTIES --------------------------------------------------------------------------------------

# Textures
export(bool) var enabled = false
export(Texture) var on_texture
export(Texture) var off_texture


# METHODS -----------------------------------------------------------------------------------------


func _ready():
	update_texture()


func update_texture() -> void:
	# Assign correct texture
	if enabled:
		texture = on_texture
	else:
		texture = off_texture


func _switched_on():
	
	# Change Texture
	texture = on_texture
	
	# Animate
	$AnimationPlayer.play("Interact")


func _switched_off():
	
	# Change Texture
	texture = off_texture
	
	# Animate
	$AnimationPlayer.play("Interact")
