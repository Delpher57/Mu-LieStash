extends StaticBody2D


export var dialogo = ""

func _on_DialogueHitBox_area_entered(area):
	if area.name == "SwordHitbox":
		DIalogueUi.iniciar_dialogo(dialogo)
