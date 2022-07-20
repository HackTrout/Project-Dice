extends Node2D


# PARTICLE SCENES

onready var boneScene := preload("res://Particles/BoneParticle.tscn")
onready var skullScene := preload("res://Particles/SkullParticle.tscn")

# METHODS

func create_particle(particleString : String, pos : Vector2, rot : float = 0.0) -> void:
	
	var scene
	match particleString:
		"bone":
			scene = boneScene
		"skull":
			scene = skullScene
		_:
			print("ERROR: No scene found!")
			return
	
	var particle = scene.instance()
	particle.position = pos
	particle.rotation = rot
	
	add_child(particle)
