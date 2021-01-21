extends AnimatedSprite

onready var animationPlayer = $AnimationPlayer

func _ready():
	
	animationPlayer.play("atackAnim")





func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "atackAnim":
		self.queue_free()
