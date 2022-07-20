extends LevelObject
class_name SwitchObject

# PROPERTIES --------------------------------------------------------------------------------------

# Switching
export(bool) var enabled : bool = false
export(bool) var toggle : bool = true
export(String) var targetGroup : String = ""
export(bool) var switchGroup : bool = true
export(bool) var ignorePlayer : bool = false

# Signals
signal switched_on
signal switched_off

# METHODS -----------------------------------------------------------------------------------------


func _ready():
	$SwitchSprite.enabled = enabled
	$SwitchSprite.update_texture()


func toggle() -> void:
	
	# Switches off object when its on and vice versa
	if enabled:
		disable()
	else:
		enable()


func quiet_enable() -> void:
	
	# CALLED TO ENABLE OBJECT
	enabled = true
	
	# Emit signal
	$SwitchSprite._switched_on()


func quiet_disable() -> void:
	
	# CALLED TO DISABLE OBJECT
	enabled = false
	
	# Emit signal
	$SwitchSprite._switched_off()


func enable() -> void:
	
	# CALLED TO ENABLE OBJECT
	enabled = true
	
	# Emit signal
	emit_signal("switched_on")
	if switchGroup: get_tree().call_group(targetGroup, "enable")
	
	# Untoggle
	if !toggle: disable()


func disable() -> void:
	
	# CALLED TO DISABLE OBJECT
	enabled = false
	
	# Emit signal
	emit_signal("switched_off")
	if switchGroup: get_tree().call_group(targetGroup, "disable")
