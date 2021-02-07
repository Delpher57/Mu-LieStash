extends CanvasLayer

var hearts = 4 setget set_hearths
var max_hearts = 4 setget set_max_hearts

var xp = 0 setget set_xp
var max_xp = 50 setget set_max_xp


onready var Hearhui_full = $UI/hearths/HearthUI_full
onready var Hearhui_empty = $UI/hearths/HearthUI_empty
onready var bar = $UI/hearths/TextureProgress
onready var health_label = $UI/hearths/Node2D
onready var health_label_text = $UI/hearths/Node2D/HEARTS
onready var anim_player = $AnimationPlayer
onready var stamina_circle = $UI/stamina/staminaCircle
onready var stamina_tween = $UI/stamina/Tween
onready var sword_indicator = $UI/Indicadores/Espada
onready var inmortal_indicator = $UI/Indicadores/Inmortal
onready var xpBar = $UI/Indicadores/Xp/TextureProgress
onready var level_up_song = $LevelUPSound

func set_hearths(value):
	hearts = clamp(value, 0, max_hearts)
	bar.value = hearts
	set_heart_label_size()
	print_hearts()


func set_max_hearts(value):
	max_hearts = max(value,1)
	bar.max_value = max_hearts
	self.hearts = max_hearts
	set_heart_label_size()
	print_hearts()

	

func start_stamina(value):
	stamina_circle.value = 0
	stamina_tween.interpolate_property(stamina_circle, "value", 0, 100, \
		value, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	stamina_tween.start()


func set_xp(value):
	xpBar.value = value
	pass

func set_max_xp(value):
	if xpBar.value != 0:
		level_up_song.play()
		anim_player.play("green")
	xpBar.max_value = value
	xpBar.value = 0
	
	pass

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	
	self.xp = PlayerStats.xp
	self.max_xp = PlayerStats.max_XP
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed",self,"set_hearths")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed",self,"set_max_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("xp_changed",self,"set_xp")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_xp_changed",self,"set_max_xp")
# warning-ignore:return_value_discarded
	PlayerStats.connect("usingDash",self,"start_stamina")
# warning-ignore:return_value_discarded
	PlayerStats.connect("sword",self,"set_sword_indicator")
# warning-ignore:return_value_discarded
	PlayerStats.connect("inmortal",self,"set_inmortal_indicator")

func shake_label():
	var shake = 5
	anim_player.play("shake")
	for i in 15:
		shake = shake - 0.33
		health_label_text.rect_pivot_offset.x = rand_range(-shake,shake)
		health_label_text.rect_pivot_offset.y = rand_range(-shake,shake)
		yield(get_tree().create_timer(.01), "timeout")
	health_label_text.rect_pivot_offset = Vector2(0,0)
	

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


func _on_AnimationPlayer_animation_finished(_anim_name):
	set_heart_label_size()


func set_heart_label_size():
	if hearts > 9:
		$NumSize.play("HPanimPlus10")
		print("plus")
	else:
		$NumSize.play("HPanimBellow9")
		print("below")
