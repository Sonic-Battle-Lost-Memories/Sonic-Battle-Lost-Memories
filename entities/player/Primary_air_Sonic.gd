extends StateMachineState

enum attack_types {GROUNDED, AERIAL}

@onready var parent:Node = get_node("..")

#time since first frame of this state.
var time_elapsed: float = 0

@export var type: attack_types
#how long this state lasts
@export var lifetime: float

#the name of the animation that this state will play
@export var main_animation:String

# identifies, in order, when each frame of the animation happens
@export var frame_times:Array[float] = [
	0.03333,
	0.06666,
	0.1333,
	0.2,
	0.25
	]
var current_time_index = 0

# state for when attack action is triggered
@export var on_primary:StateMachineState

# state for action ended
@export var on_timed_out:StateMachineState

#state for when falling character touched the floor
@export var on_touching_floor:StateMachineState

# minimum delay between the state starting and the next attack to be accepted
@export var time_till_next_hit_allowed:float



var allows_next_hit:bool = false
var next_hit_scheduled:bool = false
var was_grounded:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target: CharacterController):
	target.sprite.animation = main_animation
	
	was_grounded = target.is_on_floor()
	
	current_time_index = 0
	target.sprite.frame = 0
	
	time_elapsed  = 0
	
	allows_next_hit = false
	next_hit_scheduled = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	# advance animation to next frame as per the frame times set for this node
	if(time_elapsed >= frame_times[current_time_index]):
		current_time_index+=1
		target.sprite.frame+=1

	
	target.computeActiveMovement(delta)
	
	if(time_elapsed > 0.13 and time_elapsed < 0.315):
		#target.velocity = Vector3(0,0,0)
		target.velocity = lerp(target.velocity, Vector3(0,0,0),20*delta)
		
	target.move_and_slide()
	# check for next attack
	var is_time_for_next_hit = (time_elapsed > time_till_next_hit_allowed)
	var is_triggering_next_hit = Input.is_action_pressed("attack_primary")
	if (is_time_for_next_hit and not is_triggering_next_hit):
		allows_next_hit = true
	if (allows_next_hit and is_triggering_next_hit):
		next_hit_scheduled = true
	
	if(target.is_on_floor()):
		target.change_state(on_touching_floor)
		return

	if (time_elapsed > lifetime):
		target.computeActiveMovement(delta)
		if (next_hit_scheduled):
			target.change_state(on_primary)
			return
		else:
			target.change_state(on_timed_out)
			return
