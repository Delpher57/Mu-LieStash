extends Node2D


var stats = PlayerStats



func _on_Area2D_body_entered(body):
	stats.spawn_position = global_position
	print("DoneSPawn")
