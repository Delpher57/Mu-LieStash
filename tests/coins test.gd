extends Node2D

var COIN_SCENE = preload("res://Colectables/Orb.tscn")

const MIN_X =  20.0
const MAX_X = 50.0
const MIN_Y = -10.0
const MAX_Y =  10.0
var goal = Vector2.ZERO
var coins = []
var xp_num = 5

func _ready():
	randomize()

func throw_xp():
	coins = []

	for i in range(xp_num):
		coins.append(COIN_SCENE.instance())

		call_deferred("add_child",coins[i])

	var tween = Tween.new()
	add_child(tween)

	for coin in coins:
		var direction = 1 if randi() % 2 == 0 else -1
		goal = coin.position + Vector2(rand_range(MIN_X, MAX_X), rand_range(MIN_Y, MAX_Y)) * direction
		coin.goal_pos = goal
		tween.interpolate_property(coin, "position:x", null, goal.x, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.interpolate_property(coin, "position:y", null, goal.y - 50, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(coin, "position:y", goal.y - 50, goal.y, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN, 0.4)
		tween.interpolate_property(coin, "position:y", goal.y, goal.y - 10, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN, 0.8)
		tween.interpolate_property(coin, "position:y", goal.y - 10, goal.y, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.9)

	tween.start()
	$Timer.start()


func _on_Timer_timeout():
	for coin in coins:
		coin.get_node("Orb/shadow/sombra").following = true
		coin.get_node("Orb/CollisionShape2D").disabled = false
	coins = []
