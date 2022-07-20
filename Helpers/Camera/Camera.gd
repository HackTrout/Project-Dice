extends Camera2D


# VARIABLES

# Camera shake
var cameraShake : float = 0.0
var cameraShakeDamping : float = 0.8
var maxCameraShake : float = 32.0

# Camera target
export(NodePath) var cameraTargetPath = null
var cameraTarget = null

# Zooming
export(Vector2) var screenSize := Vector2(960.0, 540.0)
export(Vector2) var minZoom := Vector2(0.875, 0.875)
export(float) var zoomStep := 0.125

# FUNCTIONS

func _process(delta):
	
	# CAMERA SHAKE
	
	# Shake
	var shakeFactor : float = cameraShake / maxCameraShake
	offset.x = lerp(0.0, rand_range(-maxCameraShake, maxCameraShake), shakeFactor)
	offset.y = lerp(0.0, rand_range(-maxCameraShake, maxCameraShake), shakeFactor)
	
	# Damping
	cameraShake *= cameraShakeDamping
	
	# TARGETING
	if cameraTargetPath != null:
		cameraTarget = get_node(cameraTargetPath)
		if cameraTarget != null:
			
			# Move to target's position
			global_position = lerp(global_position, cameraTarget.global_position, 0.1)
			
			# Zoom out to see all of it's camera points
			var newZoom : Vector2 = minZoom
			for polygon in cameraTarget.get_children():
				if polygon is CameraPolygon:
					
					# Determine whther point is on screen
					for point in polygon.polygon:
						var globalPoint : Vector2 = (polygon.global_position + (point.rotated(polygon.global_rotation) * polygon.global_scale))
						var dif = globalPoint - global_position
						while abs(dif.x) > (screenSize.x * newZoom.x * 0.5) || abs(dif.y) > (screenSize.y * newZoom.y * 0.5):
							
							# If not increase zoom
							newZoom += Vector2.ONE * zoomStep
			
			# Interpolate to newfound zoom level
			zoom = lerp(zoom, newZoom, 0.1)
