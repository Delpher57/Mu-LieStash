extends Node


export var max_health = 1 setget set_max_health
var health = max_health setget set_health

var can_move = true
var has_sword = true setget send_signal_no_sword
var inmortal = false setget send_signal_inmortal

export var max_level = 100 #nivel maximo posible
var level = 0
export var max_XP = 20 #cantidad de xp necesaria para subir de nivel
var xp = 0



signal no_health
signal health_changed(value)
signal max_health_changed(value)
# warning-ignore:unused_signal
signal usingDash(value)
# warning-ignore:unused_signal
signal inmortal(value)
signal sword(value)

signal xp_changed(value)
signal max_xp_changed(value)

#posicion de spawn al generarse
var spawn_position = Vector2.ZERO

func set_max_health(value):
	max_health = value
	set_health(value)
	emit_signal("max_health_changed",max_health)


func set_health(value):
	health = value
	emit_signal("health_changed",health)
	if health <= 0:
		emit_signal("no_health")

func increase_xp():
	xp = xp + 1
	emit_signal("xp_changed",xp)
	if xp >= max_XP:
		subir_nivel()

func subir_nivel():
	level += 1
	xp = 0
	max_XP = int(max_XP*2)
	emit_signal("max_xp_changed",max_XP)
	set_max_health(max_health +1)

func send_signal_no_sword(value):
	emit_signal("sword",value)

func _ready():
	self.health = max_health

func send_signal_inmortal(value):
	emit_signal("inmortal",value)
