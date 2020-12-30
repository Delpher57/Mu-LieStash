extends KinematicBody2D

const DeathEffect = preload("res://Effects/EnemyDeath.tscn")
enum {
	IDLE,
	WANDER,
	CHASE
}
var state = WANDER

var velocity = Vector2.ZERO
export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 50
export var wanderDistance = 4

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
onready var hurtanim = $HurtAnim

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
				accelerate_towards_point(player.global_position,delta)
			else:
				state = IDLE

	
	if softcolition.is_colliding():
		velocity += softcolition.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(pos,delta):
	var direction =global_position.direction_to(pos)
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

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	Effects.reproducirEfect("Hit",4)
	hurtanim.play("Hurt")
	print (stats.health)
	knockback = area.knockback_vector * knockback_speed
	hurtbox.start_invincibility(0.45)
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	Effects.reproducirEfect("EnemyDie",0)
	hurtanim.play("Die")
	create_death_effect()
	queue_free()
