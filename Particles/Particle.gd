extends Particles2D


func _init() -> void:
	emitting = true


func _process(delta):
	if !emitting:
		queue_free()
