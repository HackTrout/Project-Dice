extends Node2D

export(bool) var auto = false
var mouse = false

export(NodePath) var signPath = null
var signPartner = null
export(float) var spacing : float = 128.0

func _ready():
	if auto:
		#Open
		$AnimationPlayer.play("Open")
	
	if signPath != null:
		signPartner = get_node(signPath)
		signPartner.connect("switched_on", self, "_on_entered")
		signPartner.connect("switched_off", self, "_on_exited")


func _process(delta):
	if signPartner != null:
		var dif = Vector2.UP * spacing
		global_position = lerp(global_position, signPartner.global_position + dif, 0.1)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Open":
		$AnimationPlayer.play("Idle")


func _on_entered() -> void:
	#Open
	$AnimationPlayer.play("Open")
	
	# Sounds
	SoundPlayer.play("sign_open")


func _on_exited() -> void:
	#Close
	$AnimationPlayer.play("Close")
	
	# Sounds
	SoundPlayer.play("sign_close")
