@icon("res://dev_material/nerd_moji.png")
extends StateMachineState


@onready var parent:Node = get_node("..")

#time since first frame of this state.
var time_elapsed: float = 0

@export_group("state trasitions")
# state for when attack action is triggered
@export var on_primary:StateMachineState

# state for when grounded character went into the air
@export var on_gained_air:StateMachineState

# state for action ended
@export var on_timed_out:StateMachineState

@export_group("animation")
#the name of the animation that this state will play
@export var main_animation:String

var current_time_index = 0

@export_group("trap specifications")

@export var trap_spawn_position: Vector3 = Vector3(0.3,0,0)

@export_group("action parameters")
# minimum delay between the state starting and the next attack to be accepted
@export var time_till_next_hit_allowed:float

#how long this state lasts
@export var lifetime: float


var allows_next_hit:bool = false
var next_hit_scheduled:bool = false
var was_grounded:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target: CharacterController):
	target.sprite.play(main_animation)
	
	was_grounded = target.is_on_floor()
	
	current_time_index = 0
	target.sprite.frame = 0
	print("entered p1 state")
	
	time_elapsed  = 0
	
	var new_trap = target.characterData.trap.instantiate()
	var active_trap_offset = trap_spawn_position
	if (target.current_direction == target.facing_direction.LEFT):
		active_trap_offset.x *= -1.0
	new_trap.spawn(target.position + active_trap_offset, target.trap_triggered)
	target.parent.add_child(new_trap)
	allows_next_hit = false
	next_hit_scheduled = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	#slide the character to a stop if it was previously moving
	target.velocity.x = lerp(target.velocity.x, 0.0, 10 * delta)
	target.velocity.z = lerp(target.velocity.z, 0.0, 10 * delta)
	
	target.move_and_slide()
	
	# check for next attack
	var is_time_for_next_hit = (time_elapsed > time_till_next_hit_allowed)
	var is_triggering_next_hit = Input.is_action_pressed("attack_primary")
	if (is_time_for_next_hit and not is_triggering_next_hit):
		allows_next_hit = true
	if (allows_next_hit and is_triggering_next_hit):
		next_hit_scheduled = true
	

	
	if (time_elapsed > lifetime):
		if(not target.is_on_floor()):
			target.change_state(on_gained_air)
			return
		target.computeActiveMovement(delta)
		if (next_hit_scheduled):
			target.change_state(on_primary)
			return
		else:
			target.change_state(on_timed_out)
			return
