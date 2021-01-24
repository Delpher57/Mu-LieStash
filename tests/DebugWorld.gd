extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(event):
	if Input.is_action_just_pressed("FullScreen"):
		 OS.window_fullscreen = !OS.window_fullscreen
