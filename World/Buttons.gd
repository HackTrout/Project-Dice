extends Control


func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	$Volume.pressed = SoundPlayer.mute
	$Music.pressed = SoundPlayer.get_node("Music").mute


func _on_Volume_toggled(button_pressed):
	if button_pressed == true:
		SoundPlayer.mute()
	else:
		SoundPlayer.unmute()


func _on_Music_toggled(button_pressed):
	SoundPlayer.get_node("Music").mute = button_pressed


func _on_Volume_mouse_entered():
	SoundPlayer.play("hover")
	$Volume/AnimationPlayer.play("Hover", -1, 2.0)


func _on_Volume_mouse_exited():
	$Volume/AnimationPlayer.play("HoverEnd", -1, 2.0)


func _on_Music_mouse_entered():
	SoundPlayer.play("hover")
	$Music/AnimationPlayer2.play("Hover", -1, 2.0)


func _on_Music_mouse_exited():
	$Music/AnimationPlayer2.play("HoverEnd", -1, 2.0)


func _on_Reset_pressed():
	var state = get_tree().get_nodes_in_group("player")[0].currentState
	state.exit_state(state.State.DIE)


func _on_Reset_mouse_entered():
	SoundPlayer.play("hover")
	$Reset/AnimationPlayer2.play("Hover", -1, 2.0)


func _on_Reset_mouse_exited():
	$Reset/AnimationPlayer2.play("HoverEnd", -1, 2.0)
