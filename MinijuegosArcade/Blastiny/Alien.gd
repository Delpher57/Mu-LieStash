extends KinematicBody2D


export var direction = Vector2.LEFT
var velocity = Vector2.ZERO

var MAX_SPEED = 50
var ACCELERATION = 100
var FRICTION = 100

const explotion = preload("res://MinijuegosArcade/Blastiny/pixel_Explotion.tscn")

func _process(delta):
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)


func _on_Area2D_body_entered(body):
	if body.name == "derecha":
		direction = Vector2.LEFT
		velocity = Vector2.ZERO
	elif body.name == "izquierda":
		direction = Vector2.RIGHT
		velocity = Vector2.ZERO
	
	else:
		var boom = explotion.instance()
		get_parent().add_child(boom)
		boom.global_position = global_position
		boom.emitting = true
		get_parent().num_vivos -= 1
		queue_free()



