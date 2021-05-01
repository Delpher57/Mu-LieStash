extends Area2D


const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible
onready var timer = $Timer
onready var colition = $CollisionShape2D

signal invinsibility_started
signal invinsibility_ended

func _ready():
	pass

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invinsibility_started")
	else:
		emit_signal("invinsibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var main = get_tree().current_scene
	main.create_effect(global_position)



func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invinsibility_started():
	colition.set_deferred("disabled",true)


func _on_Hurtbox_invinsibility_ended():
	colition.disabled = false
