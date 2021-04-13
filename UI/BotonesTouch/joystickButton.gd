extends TouchScreenButton

var radius = Vector2(7,7)
var boundary = 20
var deadzone = 2

var ongoing_drag = -1

var return_accel = 20

func _ready():
	position = (Vector2(0,0) - radius)

func _process(delta):

	send_action()
	if ongoing_drag == -1:
		var pos_difference = (Vector2(0,0) - radius) - position
		position += pos_difference * return_accel * delta


func get_button_pos():
	return position + radius

func _input(event):
	if event is InputEventJoypadMotion or event is InputEventKey:
		ongoing_drag = -2

	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		
		var event_distance_from_center = (event.position - get_parent().global_position).length()
		
		if event_distance_from_center <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			global_position = event.position - radius * global_scale
			if !PlayerStats.can_move:
				press_action_menu()
				pass
		
			if get_button_pos().length() > boundary:
				position = get_button_pos().normalized() * boundary - radius
			
			ongoing_drag = event.get_index()
			
	
	if event is InputEventScreenTouch and !event.is_pressed():
		if event.get_index() == ongoing_drag:
			ongoing_drag = -1

func send_action():
	
	var strengh = get_button_pos().normalized()
	
	
	if (ongoing_drag == -1 or get_button_pos().length() <= deadzone) and ongoing_drag != -2:
		strengh = Vector2.ZERO
		Input.action_press("ui_right",strengh.x)
		Input.action_press("ui_down",strengh.y)

	if get_button_pos().length() > deadzone:
		
		Input.action_press("ui_right",strengh.x)
		Input.action_press("ui_down",strengh.y)
		
func get_action():
	if get_button_pos().length() > deadzone:
		var strengh = get_button_pos().normalized()
		if strengh.y < 0:
			return "ui_up"
		else:
			return "ui_down"
	else:
		return ""


func release_action_menu(ac):

	yield(get_tree().create_timer(.01), "timeout")

	var evt = InputEventAction.new()
	evt.device = 0
	evt.action = ac
	evt.strength = 0
	evt.pressed = false
	
	get_tree().input_event(evt)
	Input.parse_input_event(evt)
	using = false

var using = false
func press_action_menu():
	if !using:
		using = true
		var evt = InputEventAction.new()
		evt.device = 0
		var action_str = get_action()
		evt.action = action_str
		evt.strength = 1
		evt.pressed = true
		
		get_tree().input_event(evt)
		Input.parse_input_event(evt)
		release_action_menu(action_str)




