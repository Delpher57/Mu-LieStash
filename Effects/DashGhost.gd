extends Sprite

func _ready():
	$alphaTween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(0,1,1,0), .6,Tween.TRANS_SINE,Tween.EASE_OUT)
	$alphaTween.start()

func _on_alphaTween_tween_completed(object, key):
	queue_free()
