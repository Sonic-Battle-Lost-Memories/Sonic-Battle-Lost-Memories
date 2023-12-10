@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

@onready var parent: Node = get_node("..")

@export_group("state transitions")
@export var on_primary: StateMachineState #state for when attack action is triggered
@export var on_gained_air: StateMachineState #state for when character is in air
@export var on_jumped: StateMachineState #state after jump action triggered
@export var on_stopped: StateMachineState #state for when movement stops
@export var on_turn_around: StateMachineState #state for when character turns around
@export var on_stopped_hard: StateMachineState #state for when character runs for `time_till_hard_stop` and then stops moving

@export_group("action parameters")
@export var time_till_hard_stop: float = 1.2 # time of constant running until a stop counts as a hard stop

@export_group("animation")
@export var main_animation: String# name of the animation for this action

var time_elapsed: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called by the character controller only on the first frame of the state
func setup(target: CharacterController):
	target.sprite.play(main_animation)
	target.allowing_double_jump = true
	time_elapsed = 0
	pass

# Called by character controller on every frame where this this state is active.
func step(target: CharacterController, delta):
	time_elapsed += delta
# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		target.jump()
		target.change_state(on_jumped)
		return
		pass

	var previous_direction = target.current_direction
	# factor in player's intended movement
	target.computeActiveMovement(delta)
	var new_direction = target.current_direction
	if(new_direction != previous_direction):
		target.change_state(on_turn_around)
		
	# actually move the character
	target.move_and_slide()
	
	# aftermath: change state if airborne or stopped
	if(Input.is_action_just_pressed("attack_primary")):
		#If attack AND stopping happened simultaneously, attack state will happen.
		target.change_state(on_primary)
		return
	if(not(target.is_on_floor())):
		target.change_state(on_gained_air)
	elif(not target.activeMovement):
		if(time_elapsed > 1.2):
			target.change_state(on_stopped_hard)
		else:
			target.change_state(on_stopped)
	pass
