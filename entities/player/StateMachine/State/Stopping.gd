@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

@onready var parent:Node = get_node("..")

@export_group("state transitions")
@export var on_primary: StateMachineState
@export var on_moved: StateMachineState
@export var on_gained_air: StateMachineState
@export var on_jumped: StateMachineState
@export var on_turn_around: StateMachineState
@export var on_timeout: StateMachineState

@export_group("action parameters")
@export var lifetime: float = 0.35

@export_group("animation")
@export var main_animation: String = "Stopping"

var time_elapsed = 0.0
var last_known_facing_direction


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target: CharacterController):
	time_elapsed = 0.0
	target.sprite.play(main_animation)
	target.allowing_double_jump = true
	last_known_facing_direction = target.current_direction
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		target.jump()
			
	# factor in player's intended movement
	target.computeActiveMovement(delta)
	target.update_facing_direction()
	
	var new_direction = target.current_direction
	
	# actually move the character
	target.move_and_slide()
	
	# aftermath: after moving, decide on which states to change into
	if(Input.is_action_just_pressed("attack_primary")):
		#If attack AND move happened simultaneously, attack state will happen.
		target.change_state(on_primary)
		return
	if(not(target.is_on_floor()) and target.velocity.y > 0.1 * target.JUMP_VELOCITY):
		target.change_state(on_jumped)
		return
	if (time_elapsed > lifetime):
		if target.activeMovement:
			if(new_direction != last_known_facing_direction):
				target.change_state(on_turn_around)
			else:
				target.change_state(on_moved)
			return
		else:
			target.change_state(on_timeout)
		return
	pass
