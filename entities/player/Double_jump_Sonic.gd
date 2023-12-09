@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

# time since this state started
var time_elapsed:float = 0.0

#how long this state lasts
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

#state for touching the floor
@export var on_grounded: StateMachineState

#state for air-attack
@export var on_primary: StateMachineState

#state for when lifetime of the animation was exceeded.
@export var on_timeout: StateMachineState

@export var time_till_air_attack: float

# how quickly the target loses momentum back into default movement speed.
@export var falloff: float

# the direction and strength of sonic ballet's propulsion, accross the horizontal and vertical components
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
	target.velocity.y = initial_impulse.y
	
	target.allowing_double_jump = false
	
	current_time_index = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	# advance animation to next frame as per the frame times set for this node
	if(current_time_index < frame_times.size() and time_elapsed >= frame_times[current_time_index]):
		current_time_index+=1
		target.sprite.frame+=1
	
	# skip to jump attack given the right circumstances
	if(Input.is_action_just_pressed("attack_primary") and time_elapsed > time_till_air_attack):
		target.change_state(on_primary)
		return
	
	# movement controls
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var active_movement = (target.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if active_movement:
#		velocity.x = lerp(velocity.x, activeMovement.x * SPEED, 6.5 * delta)
#		velocity.z = lerp(velocity.z, activeMovement.z * SPEED, 6.5 * delta)
		target.velocity = lerp(target.velocity, active_movement * target.SPEED, falloff * delta)
		target.sprite.rotation.y = atan2(target.velocity.x, target.velocity.z)
	
	# actually move the character
	target.move_and_slide()
	print("target velocity at ", target.velocity)
	# aftermath: change state if landed
	if(target.is_on_floor()):
		# you'll probably want a "landing" state here.
		target.change_state(on_grounded)
		return

	elif (time_elapsed > lifetime):
		target.change_state(on_timeout)
		return
	pass
