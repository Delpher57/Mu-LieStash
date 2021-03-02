extends TouchScreenButton

var radius = Vector2(7,7)
var boundary = 20
var deadzone = 5

var ongoing_drag = -1

var return_accel = 20

func _process(delta):
	send_action()
	if ongoing_drag == -1:
		var pos_difference = (Vector2(0,0) - radius) - position
		position += pos_difference * return_accel * delta

func get_button_pos():
	return position + radius

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_distance_from_center = (event.position - get_parent().global_position).length()
		
		if event_distance_from_center <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			global_position = event.position - radius * global_scale
		
			if get_button_pos().length() > boundary:
				position = get_button_pos().normalized() * boundary - radius
			
			ongoing_drag = event.get_index()
			
	
	if event is InputEventScreenTouch and !event.is_pressed():
		if event.get_index() == ongoing_drag:
			ongoing_drag = -1

func send_action():
	var strengh = Vector2()
	if get_button_pos().length() > deadzone:
		strengh = get_button_pos().normalized()
	else:
		strengh = Vector2.ZERO
	Input.action_press("ui_right",strengh.x)
	Input.action_press("ui_down",strengh.y)
