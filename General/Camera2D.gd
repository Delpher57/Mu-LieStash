extends Camera2D

var shake_amount = 2
onready var downRight = $Node/downright
onready var topLeft = $Node/topleft

func _ready():
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed",self,"shake")
	limit_bottom = downRight.global_position.y
	limit_top = topLeft.global_position.y
	limit_left = topLeft.global_position.x 
	limit_right = downRight.global_position.x


func shake(_num):
	print("shake")
	for _i in range(5):
		set_offset(Vector2( \
		rand_range(-1.0, 1.0) * shake_amount, \
		rand_range(-1.0, 1.0) * shake_amount ))
		yield(get_tree().create_timer(.04), "timeout")
	set_offset(Vector2(0,0))
	
	
	
	
