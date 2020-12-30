extends AudioStreamPlayer

var reproduciendo = false

func reproducirEfecto(file):
	if reproduciendo == false:
		stream = load(file)
		play()
		reproduciendo = true

func reproducirEfectoFast(file):
	stream = load(file)
	play()


func detenerEfecto():
	stop()


func _on_Effects_finished():
	reproduciendo = false


func _on_Effects5_finished():
	reproduciendo = false


func _on_Effects3_finished():
	reproduciendo = false


func _on_Effects2_finished():
	reproduciendo = false


func _on_Effects4_finished():
	reproduciendo = false
