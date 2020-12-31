extends Node

var path = "res://Music and Sounds/Effects/"
var extention = ".wav"

onready var players = [$Effects,$Effects2,$Effects3,$Effects4,$Effects5,$Effects6,$Effects7]

func reproducirEfect(file,num):
	var effect = path + file + extention
	if num == 4:
		players[num].reproducirEfectoFast(effect)
	else:
		players[num].reproducirEfecto(effect)


