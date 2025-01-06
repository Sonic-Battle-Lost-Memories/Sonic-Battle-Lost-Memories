@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

@onready var parent:Node = get_node("..")

#time since first frame of this state.
var time_elapsed: float = 0

@export_group("state transitions")
@export var on_primary:StateMachineState #state for when attack action is triggered
@export var on_timed_out:StateMachineState #state for action ended
@export var on_touching_floor:StateMachineState #falling character touched the floor

@export_group("action parameters")
@export var time_till_next_hit_allowed:float = 0.15 #minimum delay between the state starting and the next attack to be accepted
@export var lifetime: float = 0.43 #how long this state lasts

@export_group("animation")
@export var main_animation:String = "Primary_air" #the name of the animation that this state will play


var allows_next_hit:bool = false
var next_hit_scheduled:bool = false
var was_grounded:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target: CharacterController):
	target.sprite.play(main_animation)
	
	was_grounded = target.is_on_floor()
	
	time_elapsed  = 0
	
	allows_next_hit = false
	next_hit_scheduled = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	if (time_elapsed > lifetime):
		target.computeActiveMovement(delta)
		if (next_hit_scheduled):
			target.change_state(on_primary)
			return
		else:
			target.change_state(on_timed_out)
			return
	
	target.computeActiveMovement(delta)
	
	if(time_elapsed > 0.13 and time_elapsed < 0.315):
		#target.velocity = Vector3(0,0,0)
		target.velocity = lerp(target.velocity, Vector3(0,0,0),20*delta)
		
	target.move_and_slide()
	
	if(target.is_on_floor()):
		target.change_state(on_touching_floor)
		return
