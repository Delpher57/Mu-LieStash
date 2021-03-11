extends KinematicBody2D
var statestr = ""

const DeathEffect = preload("res://Effects/explosion.tscn")
const Experience = preload("res://tests/Experience.tscn")

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}
var state = WANDER

var velocity = Vector2.ZERO
export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 50
export var wanderDistance = 4
export var XP_QUANTITY = 10
export var atack_waiter = 5

var knockback = Vector2.ZERO
export var knockback_friction = 500
export var knockback_speed = 150

onready var stats = $Stats
onready var playerdetectionzone = $PlayerDetectionZone
onready var sprite = $"Minotaur - Sprite Sheet"
onready var hurtbox = $Hurtbox
onready var softcolition = $softColition
onready var wandercontroler = $wanderControler
onready var hitbox = $Hitbox
onready var camera = get_tree().get_nodes_in_group("Camera")[0]

onready var animationTree = $AnimationTree
onready var animationState =  animationTree.get("parameters/playback")


export var atacks = ["Warrior", "Magician", "Thief"]
export var shakeamount = .2

var can_atack = true

#onready var audio = $AudioStreamPlayer

var exclamation_played = false

func _ready():
	animationTree.active = true

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		
		ATTACK:

			pass
		IDLE:

			animationState.travel("IDLE")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wandercontroler.get_time_left() == 0:
				state = pick_random_state([IDLE,WANDER])
				wandercontroler.start_wander_timer(rand_range(1,3))
		
		WANDER:

			seek_player()
			if wandercontroler.get_time_left() == 0:
				state = pick_random_state([IDLE,WANDER])
				wandercontroler.start_wander_timer(rand_range(1,3))
			accelerate_towards_point(wandercontroler.target_position,delta)

			if global_position.distance_to(wandercontroler.target_position) <= wanderDistance:
				state = pick_random_state([IDLE,WANDER])
				wandercontroler.start_wander_timer(rand_range(1,3))
			
			animationState.travel("RUN")
			
			
		
		
		CHASE:

			animationState.travel("RUN")
			var player = playerdetectionzone.player
			if player != null:
				if global_position.distance_to(player.global_position) < 50:
					atack()
				accelerate_towards_point(player.global_position,delta)
				
			else:
				state = IDLE
				exclamation_played = false

	
	if softcolition.is_colliding() and state != ATTACK:
		velocity += softcolition.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(pos,delta):
	animationTree.set("parameters/ATTACK1/blend_position",global_position.direction_to(pos).normalized())
	animationTree.set("parameters/ATTACK2/blend_position",global_position.direction_to(pos).normalized())
	animationTree.set("parameters/IDLE/blend_position",global_position.direction_to(pos).normalized())
	animationTree.set("parameters/RUN/blend_position",global_position.direction_to(pos).normalized())
	var direction =global_position.direction_to(pos)
	hitbox.knockback_vectorH = direction
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	

func seek_player():
	if playerdetectionzone.can_see_player():
		state = CHASE


func create_death_effect():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	var experience = Experience.instance()
	get_parent().add_child(experience)
	experience.global_position = global_position
	experience.xp_num = XP_QUANTITY
	experience.throw_xp()

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	

func _on_Hurtbox_area_entered(area):
	if state != ATTACK:
		camera.set_trauma(shakeamount)
		$hit_anim.play("hit")
		$AudioStreamPlayer.play()
		stats.health -= area.damage
		print (stats.health)
		knockback = area.knockback_vector * knockback_speed * area.knockback_multiplier
		hurtbox.start_invincibility(0.45)
		hurtbox.create_hit_effect()


func _on_Stats_no_health():
	Effects.reproducirEfect("EnemyDie",0)
	camera.set_trauma(shakeamount*1.5)
	create_death_effect()
	queue_free()

func atack():
	#animationState.travel("IDLE")
	if can_atack == true:
		can_atack = false
		$Timer.start(atack_waiter)
		state = ATTACK
		velocity = Vector2.ZERO
		var next_atack = atacks[rand_range(0,atacks.size())]
		animationState.travel(next_atack)
	

func attack_finished():
	state = CHASE


func _on_Timer_timeout():
	can_atack = true

func play_atack():
	$hit_sound.play()
