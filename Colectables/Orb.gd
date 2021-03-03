extends Area2D

var route = "res://Music and Sounds/Effects/Orbs/Pickup_Coin_"
var format = ".wav"







func _ready():
	randomize()
	var num = str(int(rand_range(1,7)))
	var sound_name = route + num + format
	$AudioStreamPlayer2D.stream = load(sound_name)
	pass


func _on_Orb_body_entered(_body):
	PlayerStats.increase_xp()
	$orbAnim.play("hide")
	$AudioStreamPlayer2D.play()


func _on_AudioStreamPlayer2D_finished():
	print(2222)
	get_parent().queue_free()

