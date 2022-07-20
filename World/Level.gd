extends TileMap
class_name Level

# PROPERTIES --------------------------------------------------------------------------------------

# Rotating
export(bool) var automaticRotation : bool = true
export(int) var turnDirection : int = 1.0
export(Curve) var rotationCurve : Curve
export(float) var rotationDif : float = 45.0
export(float) var rotateTime : float = 1.0
export(float) var rotateCooldown : float = 1.0
onready var currentRotation : float = rotation_degrees
onready var nextRotation : float = currentRotation + (rotationDif * turnDirection)

# Turn counts
export(int) var maxTurns : int = 16
var turns : int = 0

signal rotated


# METHODS -----------------------------------------------------------------------------------------

func _ready():
	# Start cooldown
	$Timers/RotateCooldown.start(rotateCooldown)


func _physics_process(delta):
	
	# Rotate
	if !$Timers/RotateTimer.is_stopped():
		
		# Rotate level along a curve according to a timer
		var timeProgress : float = $Timers/RotateTimer.time_left / rotateTime
		print(currentRotation, ", ", nextRotation, ", ", rotation_degrees)
		rotation_degrees = lerp(currentRotation, nextRotation, rotationCurve.interpolate(1.0 - timeProgress))
		
		emit_signal("rotated", rotation)
		
		# Sounds
		if $Timers/SoundTimer.is_stopped():
			SoundPlayer.play("rotate")
			$Timers/SoundTimer.start()


func flip(turnAmount : int = 1) -> void:
	nextRotation = currentRotation + (rotationDif * turnAmount)
	$Timers/RotateTimer.start(rotateTime)


func _on_RotateTimer_timeout():
	
	# Calculate next targets
	currentRotation = nextRotation
	turns += 1
	
	# Begin cooldown
	$Timers/RotateCooldown.start(rotateCooldown)


func _on_RotateCooldown_timeout():
	# Begin rotation
	if automaticRotation:
		flip()


func _on_Sign_switched_on():
	pass # Replace with function body.
