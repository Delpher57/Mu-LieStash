extends Sprite

var inipos = Vector2.ZERO
var following = false

func _ready():
	inipos = get_parent().get_parent().get_parent().position + get_parent().get_parent().get_parent().get_parent().position

func _process(_delta):
	
	if following == false:
		position.x = get_parent().get_parent().get_parent().position.x + get_parent().get_parent().get_parent().get_parent().position.x - 25
		position.y = inipos.y + get_parent().get_parent().get_parent().goal_pos.y + 23
	else:
		position = get_parent().get_parent().get_parent().position + get_parent().get_parent().get_parent().get_parent().position
		position.x -= 25
		position.y += 23
	

