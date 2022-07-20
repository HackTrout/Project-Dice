extends AudioStreamPlayer


func mute():
	volume_db = -80


func unmute():
	volume_db = -10


func _on_Sound_finished():
	queue_free()
