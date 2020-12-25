extends KinematicBody2D

enum {IDLE, FLY, STICK}
export (float) var throw_speed = 2 * 60
onready var parent: = get_parent()
var state: int = IDLE
var velocity: = Vector2.ZERO
var pos: = Vector2.ZERO
var direccion = Vector2.ZERO
var spin_speed: float = 4*360

func _ready()->void:
	idle_position()

func _physics_process(delta):
	match state:
		IDLE:
			idle()
		FLY:
			fly(delta)
		STICK:
			stick(delta)

func idle()->void:
	$Hurtbox/CollisionShape2D.disabled = true
	pass

func fly(delta:float)->void:
	pos += velocity*delta #variable for disconnecting from parent movement
	global_position = pos
	$Hitbox.knockback_vector = velocity.normalized()


func stick(delta:float)->void:
	#place for your solution
	var target: = get_target()
	var dist = global_position.distance_to(target)
	if dist < throw_speed * delta:
		parent.has_sword = true
		queue_free()
	else:
		pos = pos.linear_interpolate(target, (throw_speed * delta)/dist)
		self.global_position = pos
		$Hitbox.knockback_vector = (target - global_position).normalized()



func throw()->void:
	state = FLY
	$Timer.start()
	$Timer2.start()
	velocity = direccion * throw_speed
	pos = global_position #variable for disconnecting from parent movement

func idle_position()->void:
	state = IDLE
	#global_position = get_target()

func get_target()->Vector2:
	return parent.global_position

#timer cantidad que dura el boomerang
func _on_Timer_timeout()->void:
	state = STICK



#timer para activar la colision
func _on_Timer2_timeout():
	$Hurtbox/CollisionShape2D.disabled = false

#en caso de colisiones
func _on_Hurtbox_area_entered(_area):
	#state = STICK
	pass

#en caso de colisiones con tilemap
func _on_Hurtbox_body_entered(_body):
	state = STICK
	pass

func set_dir_hitbox():
	$Hitbox.knockback_vector =(direccion * throw_speed).normalized()
	pass
