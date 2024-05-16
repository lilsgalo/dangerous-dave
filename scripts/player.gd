extends CharacterBody2D
signal point_added(int)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimationPlayer
@onready var sprite = $"Adventurer-sheet"
@export var speed = 500.0
@export var jump_power = -1400.0
@export var gravity_multiplier = 7
@export var health = 100
var points = 0
const acceleration = 50
const friction = 40

const max_jumps = 1
var current_jump = 0

var direction = 1
#################################################

func _physics_process(delta):
	# get player input vector
	var input_dir: Vector2 = get_player_inputs()
	
	# handle acceleration and deceleration
	if player_is_moving(input_dir) and is_on_floor():
		animation.play("running")
		accelerate(input_dir)
	elif !is_on_floor():
		animation.play("jump")
		accelerate(input_dir)
	else:
		animation.play("idle")
		add_friction()
	
	if input_dir.x > 0:
		direction = 1
	elif input_dir.x < 0:
		direction = -1
	
	# handle gravity
	gravity_handler(delta)
	
	# handle jump
	jump()
	
	# handle player movement
	move_player()
#################################################

func move_player():
	sprite.flip_h = 0 if direction == 1 else 1
	#print(direction)
	move_and_slide()

func player_is_moving(input_dir:Vector2) -> bool:
	return input_dir != Vector2.ZERO # vector2.zero => player not moving

func get_player_inputs() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("left", "right")
	return input_dir

func accelerate(dir):
	velocity = velocity.move_toward(speed * dir, acceleration)

func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)

func jump():
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		if current_jump < max_jumps:
			velocity.y = jump_power
			current_jump += 1
			#print("jumped")
		
	if is_on_floor():
		current_jump = 0
	else: # fix to jump only once, if needed to jump more than once, remove else
		current_jump = max_jumps + 1

func gravity_handler(delta):
	if not is_on_floor():
		velocity.y += gravity * gravity_multiplier * delta
	else:
		velocity.y = 0

func add_points(value:int):
	points += value
	emit_signal("point_added", value)

func _on_coin_collected():
	add_points(1)
