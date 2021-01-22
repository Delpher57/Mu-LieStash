extends Node2D

var num_vivos = 2 setget view_vivos


func view_vivos(value):
	print (value)
	if value == 0:
		$AnimationPlayer.play("fadeOut")
	num_vivos = value



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadeOut":
		PlayerStats.can_move = true
		queue_free()
