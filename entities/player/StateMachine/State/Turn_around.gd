@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

@onready var parent:Node = get_node("..")

@export_group("state transitions")
@export var on_primary: StateMachineState #attack action is triggered
@export var on_gained_air: StateMachineState #character is no longer in contact with ground
@export var on_jumped: StateMachineState #jump action triggered
@export var on_stopped: StateMachineState #character stops moving
@export var on_timed_out: StateMachineState #character is done turning

@export_group("action parameters")
@export var lifetime: float #the (limited) time this state lasts if not interrupted

@export_group("animation")
@export var main_animation: String #name of the animation.

var time_elapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called by the character controller only on the first frame of the state
func setup(target: CharacterController):
	target.sprite.play(main_animation)
	target.allowing_double_jump = true
	time_elapsed = 0.0
	pass

# Called by character controller on every frame where this this state is active.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	target.update_sprite_direction()
	if(time_elapsed > lifetime):
		target.change_state(on_timed_out)
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		target.jump()
		target.change_state(on_jumped)
		return
		pass

	# factor in player's intended movement
	target.computeActiveMovement(delta)
	
	# actually move the character
	target.move_and_slide()
	
	# aftermath: change state if airborne or stopped
	if(Input.is_action_just_pressed("attack_primary")):
		#If attack AND stopping happened simultaneously, attack state will happen.
		target.change_state(on_primary)
		return
	if(not(target.is_on_floor())):
		target.change_state(on_gained_air)
		return
	pass
