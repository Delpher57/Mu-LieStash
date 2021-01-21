extends Button

var hearts = 4 setget set_hearths

var Player = preload("res://Player/Player.tscn")
var stats = PlayerStats

func _ready():
	self.hearts = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed",self,"set_hearths")
	
func _on_Button_pressed():
	var player = Player.instance()
	get_parent().get_parent().get_node("YSort").get_node("Players").add_child(player)
	player.global_position = stats.spawn_position
	stats.health = stats.max_health
	get_parent().get_parent().get_node("YSort/Players/Elefantin").jugador = player
	hide()

func set_hearths(value):
	if value == 0:
		show()
