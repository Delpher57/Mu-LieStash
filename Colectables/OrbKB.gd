extends KinematicBody2D

var goal_pos = Vector2.ZERO

var velocity = Vector2.ZERO
export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 50

func _ready():
# warning-ignore:return_value_discarded
	$Orb.connect("kill",self,"kill")

func _physics_process(delta):
	var player
	if PlayerStats.health > 0:
		player = $Orb/PlayerDetectionZone.player
	else:
		player = null
	
	if player != null:
		accelerate_towards_point(player.global_position,delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)


func kill():
	queue_free()

func accelerate_towards_point(pos,delta):
	var direction =global_position.direction_to(pos)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
