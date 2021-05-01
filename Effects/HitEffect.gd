extends AnimatedSprite

onready var animationPlayer = $AnimationPlayer



func _on_AnimationPlayer_animation_finished(_anim_name):
	stop()
	self.hide()


func create_effect():
	self.show()
	frame = 0
	play()
	animationPlayer.play("atackAnim")
