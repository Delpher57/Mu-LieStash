extends Node2D

onready var bullet_scene = preload("res://Enemies/BulletHell/bullets/purple.tscn")
#onready var fps_label = get_node("FPS")
onready var init_position = $Position2D
export var bullet_speed = 100
var bullet_list = [];
var dead_list = [];
var frame_time = 0
var frame_count = 0

onready var dr = $DR
onready var ul = $UL
onready var bounds = {"min_x": ul.global_position.x -16, "max_x": dr.global_position.x +16, "min_y": ul.global_position.y -16, "max_y": dr.global_position.y +16}
var bullet_damage = {"damage":1, "knockback_vectorH":Vector2.ZERO}

var change = 0.0

# ===================
var change_adder = 3
var sides = 2.0
var amount = 6
#====================



func _ready():
	init_bullets(256)
	
func _process(delta):
	update_bullets(delta)
	update_pool()
	

		
func init_bullets(num):
	for _i in range(num):
		var bullet = bullet_scene.instance()
		bullet.global_position = Vector2(bounds.min_x, bounds.min_y);
		var bullet_info = {"sprite": bullet, "dx": 0, "dy": 0, "is_alive": false, "dx_change": 1, "dy_change": 1}
		dead_list.push_back(bullet_info)
		add_child(bullet)
	
func create_bullets(num, x, y):
	var max_in_pool = dead_list.size()
	if num > max_in_pool:
		num = max_in_pool
	for i in range(num):
		var bullet = dead_list[0]
		bullet.sprite.position.x = x
		bullet.sprite.position.y = y
		var circ = ((i) * PI * (sides)/ (num))  + change
		var dx = sin(circ)
		var dy = cos(circ)
		bullet.dx = dx
		bullet.dy = dy
		bullet.is_alive = true
		bullet_list.push_back(bullet)
		dead_list.pop_front()

func update_bullets(delta): 

	var player = get_tree().get_nodes_in_group("player")
	for i in range(bullet_list.size()):
		update_bullet(bullet_list[i], delta, i, player)


func update_delta(bullet):
	var cambio = -0.001
	bullet.dy = bullet.dy + (cambio * bullet.dy_change)
	if bullet.dy > 1 or bullet.dy < -1:
		bullet.dy_change *= -1
	
	bullet.dx = bullet.dx + (cambio * bullet.dx_change)
	if bullet.dx > 1 or bullet.dx < -1:
		bullet.dx_change *= -1

func update_bullet(bullet, delta, _index, player):
	if bullet.is_alive:
		bullet.sprite.position.x += bullet.dx * delta * bullet_speed
		bullet.sprite.position.y += bullet.dy * delta * bullet_speed


		if player.size() != 0 and bullet.sprite.global_position.distance_to(player[0].get_node("Hurtbox/heart").global_position) < 4:
			kill_bullet(bullet)
			player[0]._on_Hurtbox_area_entered(bullet_damage)


		
		if (bullet.sprite.global_position.x < bounds.min_x or bullet.sprite.global_position.x > bounds.max_x ||
				bullet.sprite.global_position.y < bounds.min_y || bullet.sprite.global_position.y > bounds.max_y):
			kill_bullet(bullet)

func kill_bullet(bullet):
	bullet.is_alive = false
	bullet.sprite.global_position.x = bounds.min_x
	bullet.sprite.global_position.y = bounds.min_y
	
func update_pool():
	var remove_list = []
	for i in range(bullet_list.size()):
		if bullet_list[i].is_alive == false:
			dead_list.push_back(bullet_list[i])
			remove_list.push_back(i)
			
	for i in range(remove_list.size()):
		bullet_list.remove(remove_list[i] - i)
		


 

func _on_ShootTimer_timeout():
	create_bullets(amount, init_position.position.x, init_position.position.y)
	change += change_adder


func _on_change_slider_value_changed(value):
	change_adder = value
	change = 0.0


func _on_sides_slider_value_changed(value):
	sides = value


func _on_amount_slider_value_changed(value):
	amount = value
