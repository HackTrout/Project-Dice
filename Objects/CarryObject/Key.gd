extends CarryObject
class_name Key

# PROPERTIES --------------------------------------------------------------------------------------

export(String) var targetGroup := ""

# METHODS -----------------------------------------------------------------------------------------



func _on_Hitbox_body_entered(body):
	
	var group = get_tree().get_nodes_in_group(targetGroup)
	if group.has(body.get_parent()):
		get_tree().call_group(targetGroup, "disable")
		queue_free()
