extends AnimatedSprite


func _ready():
# warning-ignore:return_value_discarded
	self.connect("animation_finished",self,"destroy")
	frame = 0
	play()

func destroy():
	queue_free()
