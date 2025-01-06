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

@export var spawnable_position: Vector3 = Vector3(0.3,0,0)


@export_group("action parameters")

@export var projectile: PackedScene

# minimum delay between the state starting and the next attack to be accepted
@export var time_till_next_hit_allowed:float

@export var vertical_impulse: float
@export var horizontal_impulse:float
#how long this state lasts
@export var lifetime: float

#cooldown variables: for tracking how long until this state can be applied again.
@export var cooldown_object: Timer
var consumed: bool = false
@onready var cooldown_counter = 0

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
	target.update_facing_direction()
	match target.active_movement_discrete:
		target.discrete_movement_direction.TOP:
			target.sprite.play(animation_up)
			target.velocity.z = 1 * horizontal_impulse
		target.discrete_movement_direction.BOTTOM:
			target.sprite.play(animation_down)
			target.velocity.z = -1 * horizontal_impulse
		_:
			target.sprite.play(animation_right)
			if(target.current_direction == target.facing_direction.RIGHT):
				target.velocity.x = -1 * horizontal_impulse
			else:
				target.velocity.x = 1 * horizontal_impulse
				
	was_grounded = target.is_on_floor()
	if(was_grounded):
		target.velocity.y = vertical_impulse * 1.4
	else:
		target.velocity.y = vertical_impulse 
	print("shot power spawning projectile.")
	time_elapsed = 0
	
	var new_spawnable = projectile.instantiate()
	var active_spawnable_offset: Vector3 = spawnable_position
	if (target.current_direction == target.facing_direction.LEFT):
		active_spawnable_offset.x *= -1.0
	var active_spawnable_direction = target.activeMovement
	new_spawnable.setup(target.position + active_spawnable_offset, target, active_spawnable_direction)
	target.parent.add_child(new_spawnable)

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	#target.computeActiveMovement(delta)
	
	target.move_and_slide()
	
	#print("checking lifetime: ", time_elapsed, ", ", delta)
	if (time_elapsed > lifetime):
		target.change_state(on_timed_out)
		trigger_cooldown()
		return
