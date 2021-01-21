extends KinematicBody2D

const DeathEffect = preload("res://Effects/EnemyDeath.tscn")
enum {
	IDLE,
	FOLLOW,
	ATACK
}
var state = ATACK

var velocity = Vector2.ZERO
export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 50
export var wanderDistance = 4

var knockback = Vector2.ZERO
export var knockback_friction = 500
export var knockback_speed = 150


onready var enemyDetector = $EnemyDetector
onready var sprite = $Sprite
onready var hitbox = $Hitbox
onready var animationTree = $AnimationTree
onready var animationState =  animationTree.get("parameters/playback")
onready var softcolition = $softColition
onready var atackaudio = $AudioStreamPlayer

onready var jugador = get_tree().get_nodes_in_group("player")

var audioplayed = false

func _ready():
	jugador = jugador[0]
	animationTree.active = true

func _physics_process(delta):
	if PlayerStats.health <= 0:
		jugador = self
	if global_position.distance_to(jugador.global_position) > 100:
				state = FOLLOW
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		FOLLOW:
			if velocity == Vector2.ZERO:
				animationState.travel("IDLE")
			else:
				animationState.travel("RUN")
			seek_player()
			if global_position.distance_to(jugador.global_position) > 150:
				global_position = jugador.global_position
			else:
				#nos detenemos al estar muy cerca
				if global_position.distance_to(jugador.global_position) < 30:
					velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
					
				else:
					accelerate_towards_point(jugador.global_position,delta)

		ATACK:
			var enemy = enemyDetector.enemy
			if enemy != null:
				accelerate_towards_point(enemy.global_position,delta)
				if global_position.distance_to(enemy.global_position) < 40:
					
					animationState.travel("ATTACK")
			else:
				state = FOLLOW
	if softcolition.is_colliding():
		velocity += softcolition.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

	

func accelerate_towards_point(pos,delta):
	animationTree.set("parameters/IDLE/blend_position",global_position.direction_to(pos).normalized())
	animationTree.set("parameters/RUN/blend_position",global_position.direction_to(pos).normalized())
	animationTree.set("parameters/ATTACK/blend_position",global_position.direction_to(pos).normalized())
	var direction =global_position.direction_to(pos)
	hitbox.knockback_vector = direction
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	

func seek_player():
	if enemyDetector.can_see_enemy():
		state = ATACK


func create_death_effect():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position

func atack_anim_ended():
	state = FOLLOW 

func playhit():
	atackaudio.play()
