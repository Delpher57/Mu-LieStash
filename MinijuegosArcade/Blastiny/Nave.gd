extends KinematicBody2D

var direction = Vector2.ZERO
var velocity = Vector2.ZERO

var MAX_SPEED = 50
var ACCELERATION = 1000000
var FRICTION = 100

const shoot = preload("res://MinijuegosArcade/Blastiny/shoot.tscn")
var can_shoot = true

func _process(_delta):
	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("boomerang") or Input.is_action_just_pressed("dash"):
		if can_shoot == true:
			can_shoot = false
			var laser = shoot.instance()
			get_parent().add_child(laser)
			laser.global_position = global_position
			$Timer.start()
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction = direction.normalized()
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
		velocity = move_and_slide(velocity)
	else:
		velocity = Vector2.ZERO


func _on_Timer_timeout():
	can_shoot = true
