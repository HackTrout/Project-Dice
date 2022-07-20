extends AudioStreamPlayer

var mute = false

func _process(delta):
	if mute:
		volume_db = -80
	else:
		volume_db = -7.5
