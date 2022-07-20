extends Node

#Sounds
onready var jump := preload("res://Sounds/jump.wav")
onready var land := preload("res://Sounds/land.wav")
onready var interact := preload("res://Sounds/interact.wav")
onready var pickup := preload("res://Sounds/pickup.wav")
onready var drop := preload("res://Sounds/drop.wav")
onready var step0 := preload("res://Sounds/step0.wav")
onready var step1 := preload("res://Sounds/step1.wav")
onready var die := preload("res://Sounds/die.wav")
onready var finish_level := preload("res://Sounds/finish_level.wav")
onready var set_plane := preload("res://Sounds/set_plane.wav")
onready var sign_open := preload("res://Sounds/sign_open.wav")
onready var sign_close := preload("res://Sounds/sign_close.wav")
onready var hover := preload("res://Sounds/hover.wav")
onready var rotate := preload("res://Sounds/rotate.wav")

#Sound
onready var sound_scene := preload("res://Sounds/Sound.tscn")
var mute = false

func mute():
	get_tree().call_group("sound", "mute")
	mute = true


func unmute():
	get_tree().call_group("sound", "unmute")
	mute = false


func play(s: String) -> void:
	var sound = sound_scene.instance()
	
	match s:
		"jump":
			sound.stream = jump
		"land":
			sound.stream = land
		"interact":
			sound.stream = interact
		"pickup":
			sound.stream = pickup
		"drop":
			sound.stream = drop
		"walk":
			if rand_range(0.0, 1.0) > 0.5:
				sound.stream = step0
			else:
				sound.stream = step1
		"die":
			sound.stream = die
		"finish_level":
			sound.stream = finish_level
		"set_plane":
			sound.stream = set_plane
		"sign_open":
			sound.stream = sign_open
		"sign_close":
			sound.stream = sign_close
		"hover":
			sound.stream = hover
		"rotate":
			sound.stream = rotate
		"climb":
			sound.stream = step1
	
	sound.pitch_scale += rand_range(0.25, -0.25)
	
	if mute: sound.volume_db = -80
	
	add_child(sound)
