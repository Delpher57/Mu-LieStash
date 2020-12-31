extends Area2D

var enemy = null

func can_see_enemy():
	return enemy != null

func _on_EnemyDetector_area_entered(area):
	enemy = area


func _on_EnemyDetector_area_exited(_area):
	enemy = null
