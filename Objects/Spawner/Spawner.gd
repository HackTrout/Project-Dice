extends LevelObject
class_name Spawner

# PROPERTIES --------------------------------------------------------------------------------------

# Scene to spawn
export(String) var scenePath
export(bool) var autoSpawn : bool = true
export(bool) var respawnObject : bool = false
export(NodePath) var parentObjectPath = null
export(float) var spawnCooldown : float = 1.0
var spawnTimer : Timer

# METHODS -----------------------------------------------------------------------------------------


func _ready():
	
	# Create timer
	spawnTimer = Timer.new()
	spawnTimer.one_shot = true
	spawnTimer.autostart = false
	add_child(spawnTimer)
	
	spawnTimer.connect("timeout", self, "spawn")
	
	# Start spawning
	if autoSpawn:
		begin_spawning()


func begin_spawning() -> void:
	
	# Spawn right away if there's no cooldown
	if spawnCooldown == 0.0:
		spawn()
		return
	
	# Start cooldown timer
	spawnTimer.start(spawnCooldown)


func spawn() -> void:
	
	# Load and instance scene from path
	var object = load(scenePath).instance()
	object.position = position
	
	# Plan to respawn object
	if respawnObject: object.connect("exit_tree", self, "begin_spawning")
	
	#  Add child to specified object or to spawner's parent by default
	if parentObjectPath != null:
		get_node(parentObjectPath).add_child(object)
	else:
		get_parent().add_child(object)
