extends Area2D


signal hablar



func _on_TalkBox_area_entered(area):
	emit_signal("hablar")
	DIalogueUi.iniciar_dialogo("elefantin1")
	print ("z")
