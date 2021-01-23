extends AnimatedSprite

onready var animationPlayer = $AnimationPlayer

func _ready():
	frame = 0
	play()
	animationPlayer.play("atackAnim")





func _on_AnimationPlayer_animation_finished(_anim_name):
	stop()
	self.queue_free()


