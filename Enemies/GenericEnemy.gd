extends KinematicBody2D

const DeathEffect = preload("res://Effects/explosion.tscn")
const Experience = preload("res://tests/Experience.tscn")
enum {
	IDLE,
	WANDER,
	CHASE,
	AVOID
}
var state = WANDER

var velocity = Vector2.ZERO
export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 50
export var wanderDistance = 4
export var XP_QUANTITY = 5

var knockback = Vector2.ZERO
export var knockback_friction = 500
export var knockback_speed = 150

onready var stats = $Stats
onready var playerdetectionzone = $PlayerDetectionZone
onready var sprite = $Sprite
onready var hurtbox = $Hurtbox
onready var softcolition = $softColition
onready var wandercontroler = $wanderControler
onready var hitbox = $Hitbox
onready var camera = get_tree().get_nodes_in_group("Camera")[0]

onready var hurtanim = $HurtAnim
onready var exclamationAnim = $ExclamationAnim
onready var audio = $AudioStreamPlayer

var exclamation_played = false
export var shakeamount = .2

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
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
			
			
		
		
		CHASE:
			var player = playerdetectionzone.player
			if player != null:
				if exclamation_played == false:
					exclamationAnim.play("exclamation")
					exclamation_played = true
				change_fight_behavior()
				accelerate_towards_point(player.global_position,delta)
			else:
				state = IDLE
				exclamation_played = false
		
		AVOID:
			var player = playerdetectionzone.player
			if player != null:
				if exclamation_played == false:
					exclamationAnim.play("exclamation")
					exclamation_played = true
				change_fight_behavior()
				accelerate_against_point(player.global_position,delta)
				if velocity.x == 0 or velocity.y == 0:
					state = CHASE
			else:
				state = IDLE
				exclamation_played = false

	
	if softcolition.is_colliding():
		velocity += softcolition.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(pos,delta):
	var direction =global_position.direction_to(pos)
	hitbox.knockback_vectorH = direction
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func accelerate_against_point(pos,delta):
	var direction =global_position.direction_to(pos) * -1
	hitbox.knockback_vectorH = direction
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0


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
	camera.set_trauma(shakeamount)
	stats.health -= area.damage
	audio.play()
	hurtanim.play("Hurt")
	exclamationAnim.play("hideExclamation")
	knockback = area.knockback_vector * knockback_speed * area.knockback_multiplier
	hurtbox.start_invincibility(0.45)
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	Effects.reproducirEfect("EnemyDie",0)
	camera.set_trauma(shakeamount*1.5)
	create_death_effect()
	$DieAnim.play("Die")




func _on_DieAnim_animation_finished(anim_name):
	if (anim_name == "Die"):
		queue_free()

#cambiamos entre rer o atacar en una batalla
func change_fight_behavior():
	
	if $AttackorRunTimer.get_time_left() == 0:
		state = pick_random_state([CHASE,AVOID])
		$AttackorRunTimer.start(rand_range(3,7))
		
