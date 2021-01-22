extends KinematicBody2D


export var direction = Vector2.UP
var velocity = Vector2.ZERO

var MAX_SPEED = 80
var ACCELERATION = 10000000
var FRICTION = 100

func _process(_delta):
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	velocity = move_and_slide(velocity)




func _on_Area2D_area_entered(area):
	if area.name == "top":
		queue_free()
