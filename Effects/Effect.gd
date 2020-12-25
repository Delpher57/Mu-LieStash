extends AnimatedSprite


func _ready():
	self.connect("animation_finished",self,"destroy")
	frame = 0
	play()

func destroy():
	queue_free()
