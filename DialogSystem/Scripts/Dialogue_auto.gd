extends Area2D


export var dialogo = ""



func _on_Dialogue_auto_body_entered(_body):
	DIalogueUi.iniciar_dialogo(dialogo)
	queue_free()
