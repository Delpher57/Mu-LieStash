extends KinematicBody2D

var goal_pos = Vector2.ZERO

var velocity = Vector2.ZERO
export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 50

func _process(delta):
	var player = $Orb/PlayerDetectionZone.player
	if player != null:
		accelerate_towards_point(player.global_position,delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if $softColition.is_colliding():
		velocity += $softColition.get_push_vector() * delta * 100
	velocity = move_and_slide(velocity)

func accelerate_towards_point(pos,delta):
	var direction =global_position.direction_to(pos)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
