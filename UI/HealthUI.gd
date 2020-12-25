extends CanvasLayer

var hearts = 4 setget set_hearths
var max_hearts = 4 setget set_max_hearts

onready var Hearhui_full = $hearths/HearthUI_full
onready var Hearhui_empty = $hearths/HearthUI_empty

func set_hearths(value):
	hearts = clamp(value, 0, max_hearts)
	if Hearhui_full != null:
		Hearhui_full.rect_size.x = hearts * 15

func set_max_hearts(value):
	max_hearts = max(value,1)
	self.hearts = min(hearts,max_hearts)
	if Hearhui_empty != null:
		Hearhui_empty.rect_size.x = max_hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed",self,"set_hearths")
	PlayerStats.connect("max_health_changed",self,"set_max_hearths")

