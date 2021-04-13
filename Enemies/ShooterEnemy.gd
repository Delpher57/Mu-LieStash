extends KinematicBody2D

const DeathEffect = preload("res://Effects/explosion.tscn")
export var Laser = preload("res://Enemies/lasers/Laser.tscn")
const Experience = preload("res://tests/Experience.tscn")

export var shoot_time_range_min = 3.0
export var shoot_time_range_max = 5.0

enum {
	IDLE,
	WANDER,
	CHASE,
	SHOOT,
	AVOID
}
var state = WANDER

var velocity = Vector2.ZERO

export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 50
export var wanderDistance = 4
export var rango_vision_disparo = 200
export var XP_QUANTITY = 6
export var shakeamount = .2

export var shoot_animations = 1
onready var animations = $AnimationPlayer

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

onready var hurt_anim = $HurtAnim
onready var hurt_sound = $HurtSound
onready var shoot_timer = $ShootTimer

var can_shoot = true

func _physics_process(delta):
	
	knockback = knockback.move_toward(Vector2.ZERO, knockback_friction * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			animations.play("IDLE")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wandercontroler.get_time_left() == 0:
				change_idle_behavior()
		
		WANDER:
			animations.play("RUN")
			seek_player()
			if wandercontroler.get_time_left() == 0:
				change_idle_behavior()
			
			accelerate_towards_point(wandercontroler.target_position,delta)
			
			if global_position.distance_to(wandercontroler.target_position) <= wanderDistance:
				change_idle_behavior()
		
		CHASE:
			animations.play("RUN")
			var player = playerdetectionzone.player
			if player != null:
				accelerate_towards_point(player.global_position,delta)
				
				if global_position.distance_to(player.global_position) < rango_vision_disparo/3:
					change_fight_behavior(AVOID)
				
				if global_position.distance_to(player.global_position) < rango_vision_disparo:
					if can_shoot == true:
						shoot(player)
			else:
				state = IDLE
		
		AVOID:
			animations.play("RUN")
			var player = playerdetectionzone.player
			if player != null:
				accelerate_against_point(player.global_position,delta)
				
				if global_position.distance_to(player.global_position) > rango_vision_disparo/2:
					change_fight_behavior(CHASE)
				
				if abs(velocity.x) < .1 and abs(velocity.y) < .1: 
					state = CHASE
				
				if global_position.distance_to(player.global_position) < rango_vision_disparo:
					if can_shoot == true:
						shoot(player)
			else:
				state = IDLE
		SHOOT:
			pass
	
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


func get_shoot_anim():
	var anim = randi()%shoot_animations + 1
	var animation_name = "SHOOT" + str(anim)
	return animation_name
	


func shoot(player):
	state = CHASE
	state = SHOOT
	animations.play(get_shoot_anim())
	velocity = Vector2.ZERO
	can_shoot = false
	shoot_timer.wait_time = rand_range(shoot_time_range_min,shoot_time_range_max)
	shoot_timer.start()
	var laser = Laser.instance()
	get_parent().add_child(laser)
	laser.global_position = global_position
	laser.direction = global_position.direction_to(player.global_position).normalized()



func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func _on_Hurtbox_area_entered(area):
	camera.set_trauma(shakeamount)
	stats.health -= area.damage
	hurt_sound.play()
	hurt_anim.play("hurt")
	
	knockback = area.knockback_vector * knockback_speed * area.knockback_multiplier
	hurtbox.start_invincibility(0.3)
	hurtbox.create_hit_effect()
	state = AVOID

func create_death_effect():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	
	var experience = Experience.instance()
	get_parent().add_child(experience)
	experience.global_position = global_position
	experience.xp_num = XP_QUANTITY
	experience.throw_xp()

func _on_Stats_no_health():
	Effects.reproducirEfect("EnemyDie",0)
	camera.set_trauma(shakeamount*1.5)
	create_death_effect()
	queue_free()

func _on_ShootTimer_timeout():
	can_shoot = true

#cambiamos entre AVOID o CHASE en una batalla
func change_fight_behavior(new_state):
	if $AttackorRunTimer.get_time_left() < 0.05:
		print("cambiando de estado")
		state = new_state
		$AttackorRunTimer.start(1)

#cambiamos el estado entre IDLE y WANDER
func change_idle_behavior():
	state = pick_random_state([IDLE,WANDER])
	wandercontroler.start_wander_timer(rand_range(1,3))

func atack_anim_ended():
	state = CHASE
