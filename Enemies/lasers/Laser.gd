extends KinematicBody2D


export var direction = Vector2.ZERO
var velocity = Vector2.ZERO

export var MAX_SPEED = 80
var ACCELERATION = 10000000
var FRICTION = 100



func _process(_delta):
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	velocity = move_and_slide(velocity)



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Summonn":
		$AnimationPlayer.play("Pulse")


func _on_VisibilityEnabler2D_viewport_exited(_viewport):
	pass
	


# warning-ignore:unused_argument
func _on_Hitbox_area_entered(area):
	$AnimationPlayer.play("DIE")


func _on_VisibilityEnabler2D_screen_exited():
	queue_free()


# warning-ignore:unused_argument
func _on_Hitbox_body_entered(body):
	$AnimationPlayer.play("DIE")


func stop_movement():
	velocity = Vector2.ZERO
	MAX_SPEED = 0
