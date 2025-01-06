@icon("res://dev_material/nerd_moji.png")
extends StateMachineState


@onready var parent:Node = get_node("..")

#time since first frame of this state.
var time_elapsed: float = 0

@export_group("state trasitions")

# state for action ended
@export var on_timed_out:StateMachineState

@export_group("animation")

# the name of the animation that this state will play
@export var animation_right: String
@export var animation_up: String
@export var animation_down: String


var current_time_index = 0

@export_group("trap specifications")

@export var trap_spawn_position: Vector3 = Vector3(0.3,0,0)


@export_group("action parameters")
# minimum delay between the state starting and the next attack to be accepted
@export var time_till_next_hit_allowed:float

#how long this state lasts
@export var lifetime: float

#cooldown variables: for tracking how long until this state can be applied again.
@export var cooldown_object: Timer
var consumed: bool = false
@onready var cooldown_counter = 0

var allows_next_hit:bool = false
var next_hit_scheduled:bool = false
var was_grounded:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_ready():
	return (not consumed)

func trigger_cooldown():
	cooldown_object.start()

func _physics_process(delta):
	if(cooldown_object.time_left <=0):
		state_enabled = true
	else:
		state_enabled = false

func setup(target: CharacterController):
	match target.active_movement_discrete:
		target.discrete_movement_direction.TOP:
			target.sprite.play(animation_up)
		target.discrete_movement_direction.BOTTOM:
			target.sprite.play(animation_down)
		_:
			target.sprite.play(animation_right)
	was_grounded = target.is_on_floor()
	
	print("triggered shot power on ground.")
	time_elapsed = 0
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	#slide the character to a stop if it was previously moving
	target.velocity.x = lerp(target.velocity.x, 0.0, 10 * delta)
	target.velocity.z = lerp(target.velocity.z, 0.0, 10 * delta)
	
	target.move_and_slide()
	
	#print("checking lifetime: ", time_elapsed, ", ", delta)
	if (time_elapsed > lifetime):
		target.change_state(on_timed_out)
		return
