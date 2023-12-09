extends StateMachineState

@onready var parent: Node = get_node("..")

# state for when attack action is triggered
@export var on_primary: StateMachineState

# state for when character is in air
@export var on_gained_air: StateMachineState

@export var on_jumped: StateMachineState

# state for action ended
@export var on_stopped: StateMachineState

@export var on_turn_around: StateMachineState
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called by the character controller only on the first frame of the state
func setup(target: CharacterController):
	target.sprite.play("run")
	target.allowing_double_jump = true
	pass

# Called by character controller on every frame where this this state is active.
func step(target: CharacterController, delta):
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
		target.change_state(on_stopped)
	pass
