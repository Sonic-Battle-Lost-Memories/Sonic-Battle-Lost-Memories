@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

# time since this state started
var time_elapsed:float = 0.0

@export var jump_state_name = "Jumping"
@export var lifetime:float = 0.3666

#the name of the animation that this state will play
@export var main_animation:String

# identifies, in order, when each frame of the animation happens
@export var frame_times:Array[float] = [
	0.03333,
	0.0833,
	0.1333,
	0.2,
	0.2333,
	0.28333
	]
var current_time_index = 0

@onready var parent: Node = get_node("..")

@export_group("transition")
#state for touching the floor
@export var on_grounded: StateMachineState

#state for air-attack
@export var on_primary: StateMachineState

#state for when lifetime of the animation was exceeded.
@export var on_timeout: StateMachineState

@export var time_till_air_attack: float

@export var initial_impulse: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func setup(target:CharacterController):
	target.sprite.animation = main_animation
	target.sprite.frame = 0
	time_elapsed = 0
	
	var inherited_direction = Vector2(target.velocity.x, target.velocity.z).normalized()
	#initial impulse on character
	target.velocity.x = (inherited_direction.x * initial_impulse.x)
	target.velocity.z = (inherited_direction.y * initial_impulse.x)
	#target.velocity.y = initial_impulse.y
	
	#target.allowing_double_jump = false
	
	current_time_index = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
# Handle Jump.
	#if Input.is_action_just_pressed("jump") and !target.respawning:
		#target.jump()
		#pass
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (target.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		target.velocity.x = lerp(target.velocity.x, direction.x * target.SPEED, 10.5 * delta)
		target.velocity.z = lerp(target.velocity.z, direction.z * target.SPEED, 10.5 * delta)
		target.sprite.rotation.y = atan2(target.velocity.x, target.velocity.z)
		target.sprite.animation = "run"
	else:
		target.velocity.x = lerp(target.velocity.x, 0.0, 10 * delta)
		target.velocity.z = lerp(target.velocity.z, 0.0, 10 * delta)
		target.sprite.animation = "idle"
	
	#if velocity.y >= 0:
		#sprite.animation = "jump"
	
	if direction.x <= -0.5:
		target.sprite.flip_h = true
	elif direction.x >= 0.5:
		target.sprite.flip_h = false
	
	target.move_and_slide()
	if(not(target.is_on_floor())):
		target.sprite.animation = "jump"
	pass
