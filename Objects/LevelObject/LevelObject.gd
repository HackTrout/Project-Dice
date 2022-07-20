extends Node2D
class_name LevelObject

# PROPERTIES --------------------------------------------------------------------------------------

# Level parent
onready var level : Level = get_parent().get_parent()
export(bool) var rotateAppearance : bool = false		# If true, object will always try to appear right side up

# METHODS -----------------------------------------------------------------------------------------


func _ready():
	connect_signals()


func connect_signals() -> void:
	
	# Connect signals
	if rotateAppearance: level.connect("rotated", self, "rotate_appearance")


func rotate_appearance(newRot : float) -> void:
	
	# ROTATE SELF TO ALWAYS APPEAR RIGHT SIDE UP
	rotation = -newRot
