extends KinematicBody2D


onready var talkbox = $TalkBox

func _ready():
	talkbox.connect("hablar",self,"iniciar_dialog")
	DIalogueUi.iniciar_dialogo("elefantin1")




func iniciar_dialog(area):
	DIalogueUi.iniciar_dialogo("elefantin1")
	print ("dialogo on")




func _on_TalkBox_hablar():
	DIalogueUi.iniciar_dialogo("elefantin1")
	print ("dialogo on2")


func _on_TalkBox_area_entered(area):
	pass # Replace with function body.
