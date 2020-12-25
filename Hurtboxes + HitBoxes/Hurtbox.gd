extends Area2D


const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible
onready var timer = $Timer

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
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invinsibility_started():
	set_deferred("monitoring",false)


func _on_Hurtbox_invinsibility_ended():
	monitoring = true
