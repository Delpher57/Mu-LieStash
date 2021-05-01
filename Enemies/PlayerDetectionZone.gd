extends Area2D

export var stop_following = true

var player = null

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body


func _on_PlayerDetectionZone_body_exited(_body):
	if stop_following:
		player = null
