extends Node2D


const HitEffect = preload("res://Effects/HitEffect.tscn")
var amount = 24
var effects = []


# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("FullScreen"):
		 OS.window_fullscreen = !OS.window_fullscreen


func _ready():
	for i in amount:
		var effect = HitEffect.instance()
		effects.push_back(effect)
		add_child(effect)
		effect.hide()

func create_effect(pos):
	var d_effect = effects[0]
	d_effect.global_position = pos
	d_effect.create_effect()

	effects.pop_front()
	effects.push_back(d_effect)
