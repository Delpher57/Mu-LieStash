extends Camera2D

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

export var shake_amount = 2
onready var downRight = $Node/downright
onready var topLeft = $Node/topleft
onready var animationPlayer = $AnimationPlayer


export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3]

func _ready():
# warning-ignore:return_value_discarded
	global_position = get_node(target).global_position
	PlayerStats.connect("health_changed",self,"shake")
	limit_bottom = downRight.global_position.y
	limit_top = topLeft.global_position.y
	limit_left = topLeft.global_position.x 
	limit_right = downRight.global_position.x
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _process(delta):
	var player = get_node_or_null(target)
	if player != null:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		normalshake()

func shake(_num):
	animationPlayer.play("hurtFlash")
	trauma = .55

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)


func normalshake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
