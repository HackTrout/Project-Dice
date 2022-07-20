extends CanvasLayer

var nextScenePath = ""


func reload() -> void:
	nextScenePath = ""
	$Transition/AnimationPlayer.play("Enter")


func change_scene(path : String) -> void:
	nextScenePath = path
	$Transition/AnimationPlayer.play("Enter")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Enter":
		
		if nextScenePath == "":
			get_tree().reload_current_scene()
		else:
			get_tree().change_scene(nextScenePath)
