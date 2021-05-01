extends KinematicBody2D

export var MAX_SPEED = 100
export var DASH_SPEED = 275
export var ACCELERATION = 700
export var FRICTION = 700

enum {
	MOVE,
	DASH,
	ATTACK,
	BOOMERANG
}

var state = MOVE
var velocity = Vector2.ZERO
var dash_vector = Vector2.RIGHT
var stats = PlayerStats


#le mandamos esto al boomerang para saber la dirección
var direccion_vision = Vector2.RIGHT


var can_dash = true
var is_atacking = false
var is_talking = false
var has_sword = true

#knockback al ser golpeados
var knockback = Vector2.ZERO
export var knockback_friction = 500
export var knockback_speed = 150

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState =  animationTree.get("parameters/playback")
onready var trail = $trail
onready var sword = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkanim = $BlinkAnimation
onready var dashanim = $DashAnimation
onready var camera = get_tree().get_nodes_in_group("Camera")[0]

export var invincibility_time = 0.5
var Boomerang = preload ("res://Player/Boomerang.tscn")

func _ready():
	stats.connect("no_health",self,"queue_free")
	sword.knockback_vector = dash_vector
	animationTree.active = true
	stats.can_move = true

	


func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		_on_Hurtbox_area_entered(bullet_damage)
	match state:
		MOVE:
			move_state(delta)
		
		DASH:
			dash_state(delta)
		
		ATTACK:
			atack_state(delta)
		
		BOOMERANG:
			boomerang_state(delta)



func move_state(delta):
	is_talking = false
	if stats.can_move == false:
		trail.emitting = false
		animationState.travel("Idle")
		velocity = Vector2.ZERO
		knockback = Vector2.ZERO
		is_talking = true
	else:
		knockback = knockback.move_toward(Vector2.ZERO, knockback_friction * delta)
		knockback = move_and_slide(knockback)
		
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		
		
		if input_vector != Vector2.ZERO:
			trail.emitting = true
			Effects.reproducirEfect("Walking",1)
			direccion_vision = input_vector
			dash_vector = input_vector
			sword.knockback_vector = input_vector
			
			animationTree.set("parameters/Idle/blend_position",input_vector)
			animationTree.set("parameters/Run/blend_position",input_vector)
			animationTree.set("parameters/Attack/blend_position",input_vector)
			animationTree.set("parameters/Boomerang/blend_position",input_vector)
			animationState.travel("Run")
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			
			if Input.is_action_just_pressed("dash"):
				if can_dash == true:
					$DashAudio.play()
					state = DASH
		else:
			trail.emitting = false
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO,FRICTION * delta)
		
		move()
		
		if Input.is_action_just_pressed("attack"):
			if has_sword == true:
				atack()
				state = ATTACK
		
		if Input.is_action_just_pressed("boomerang"):
			if has_sword == true:
				$BoomerangThrowSound.play()
				state = BOOMERANG

func atack():
	#animationState.travel("Attack")
	animationState.start("Attack")
	Effects.reproducirEfect("SwordSlash",4)
	Input.start_joy_vibration(0,0.05,0.06,0.06)
	is_atacking = true
	camera.set_trauma(.1)
	

func atack_state(_delta):
	velocity = Vector2.ZERO
	if Input.is_action_just_pressed("attack"):
			if has_sword == true and is_atacking == false:
				atack()
				state = ATTACK
	pass

func boomerang_state(_delta):
	if has_sword == true:
		Input.start_joy_vibration(0,0.05,0.06,0.06)
		has_sword = false
		stats.has_sword = false
		var boomerang = Boomerang.instance()
		add_child(boomerang)
		boomerang.direccion = direccion_vision
		boomerang.set_dir_hitbox()
		boomerang.throw()
		camera.set_trauma(.2)
		velocity = Vector2.ZERO
		animationState.travel("Boomerang")
		stats.has_sword = false
		
	pass

func dash_state(_delta):
	Input.start_joy_vibration(0,0.05,0.06,0.1)
	can_dash = false
	dashanim.play("dash")
	
	hurtbox.start_invincibility(.5)
	camera.set_trauma(.01)
	stats.emit_signal("usingDash",$Timer.wait_time)
	
	$Timer.start()
	$particle_timer.start()
	$dash_particles/sparks.emitting = true
	$dash_particles/trail2.emitting = true
	$dash_particles/linea.emitting = true
	
	animationState.travel("Run")
	velocity = dash_vector * DASH_SPEED
	state = MOVE

func move():
	velocity = move_and_slide(velocity)

func attack_anim_finished():
	state = MOVE
	animationState.travel("Idle")

func coyote_atack():
	is_atacking = false

func boomerang_anim_finished():
	#has_sword = false
	state = MOVE



#finalizacion del dash
func _on_Timer_timeout():
	can_dash = true

func _on_particle_timer_timeout():
	$dash_particles/sparks.emitting = false
	$dash_particles/trail2.emitting = false



var bullet_damage = {"damage":1, "knockback_vectorH":Vector2.ZERO}
func _on_Hurtbox_area_entered(area):

	if is_talking == false and hurtbox.invincible == false:
		Effects.reproducirEfect("Hurt",6)
		Input.start_joy_vibration(0,0.9,1,0.2)
		
		hurtbox.start_invincibility(invincibility_time)
		hurtbox.create_hit_effect()
		stats.health -= area.damage
		knockback = area.knockback_vectorH * knockback_speed

#con estas dos manejamos el blink
func _on_Hurtbox_invinsibility_started():
	stats.inmortal = true
	if can_dash == true:
		blinkanim.play("Start")


func _on_Hurtbox_invinsibility_ended():
	blinkanim.play("Stop")
	stats.inmortal = false
