extends CanvasLayer

var hearts = 4 setget set_hearths
var max_hearts = 4 setget set_max_hearts


onready var Hearhui_full = $hearths/HearthUI_full
onready var Hearhui_empty = $hearths/HearthUI_empty
onready var bar = $hearths/TextureProgress
onready var health_label = $hearths/Node2D
onready var health_label_text = $hearths/Node2D/HEARTS
onready var anim_player = $AnimationPlayer
onready var stamina_circle = $stamina/staminaCircle
onready var stamina_tween = $stamina/Tween
onready var sword_indicator = $Indicadores/Espada
onready var inmortal_indicator = $Indicadores/Inmortal

func set_hearths(value):
	hearts = clamp(value, 0, max_hearts)
	print_hearts()
	bar.value = hearts

	if Hearhui_full != null:
		Hearhui_full.rect_size.x = hearts * 18

func set_max_hearts(value):
	max_hearts = max(value,1)
	print_hearts()
	bar.max_value = max_hearts
	self.hearts = min(hearts,max_hearts)
	if Hearhui_empty != null:
		Hearhui_empty.rect_size.x = max_hearts * 18

func start_stamina(value):
	stamina_circle.value = 0
	stamina_tween.interpolate_property(stamina_circle, "value", 0, 100, \
		value, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	stamina_tween.start()


func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed",self,"set_hearths")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed",self,"set_max_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("usingDash",self,"start_stamina")
# warning-ignore:return_value_discarded
	PlayerStats.connect("sword",self,"set_sword_indicator")
# warning-ignore:return_value_discarded
	PlayerStats.connect("inmortal",self,"set_inmortal_indicator")

func shake_label():
	anim_player.play("shake")
	

func print_hearts():
	var stringH = ""
	stringH += (str(hearts))
	stringH += ("/")
	stringH += (str(max_hearts))
	health_label_text.text = stringH
	if hearts != max_hearts:
		shake_label()

func set_sword_indicator(value):
	if value == true:
		sword_indicator.value = 1
	else:
		sword_indicator.value = 0
		
func set_inmortal_indicator(value):
	if value == true:
		inmortal_indicator.value = 1
	else:
		inmortal_indicator.value = 0


func _on_AnimationPlayer_animation_finished(anim_name):
	if hearts > 9:
		$NumSize.play("HPanimPlus10")
	else:
		$NumSize.play("HPanimBellow9")
