extends KinematicBody2D
class_name CarryObject

# PROPERTIES --------------------------------------------------------------------------------------

# Textures
export(Texture) var texture

# Motion
var velocity := Vector2.ZERO
export(float) var gravity := 20.0
export(float, 0.0, 1.0, 0.01) var groundFriction := 0.8
export(float, 0.0, 1.0, 0.01) var airFriction := 0.85


# METHODS -----------------------------------------------------------------------------------------


func _ready():
	
	# Assign Texture
	$Sprite.texture = texture


func _physics_process(delta):
	
	# Apply gravity and friction
	if is_on_floor():
		velocity *= groundFriction
	else:
		velocity.y += gravity
		velocity *= airFriction
	
	# Move
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Rotate Object
	rotation = -get_parent().get_parent().rotation
