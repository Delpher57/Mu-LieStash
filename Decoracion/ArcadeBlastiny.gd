extends StaticBody2D


const Game = preload("res://MinijuegosArcade/Blastiny/Blastiny.tscn")

func _on_playHitbox_area_entered(_area):
	PlayerStats.can_move = false
	$CanvasLayer/DialogueUI.show()
	$CanvasLayer/DialogueUI.dialogueButtons[0].grab_focus()

#botonJugar
func _on_DialogueButton_pressed():
	var game = Game.instance()
	call_deferred("add_child", game)
	
	$CanvasLayer/DialogueUI.hide()

#boton no
func _on_DialogueButton2_pressed():
	$CanvasLayer/DialogueUI.hide()
	PlayerStats.can_move = true

#boton si
func _on_DialogueButton3_pressed():
	$saveSound.play()
	PlayerStats.spawn_position = $respawnPos.global_position
	$CanvasLayer/DialogueUI.hide()
	PlayerStats.can_move = true
