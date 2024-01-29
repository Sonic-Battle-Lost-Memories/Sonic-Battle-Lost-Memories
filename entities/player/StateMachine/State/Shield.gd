@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

@export_group("shield properties")
##the amount of time before the player start's healing
@export var time_till_heal: float


#the timer
@onready var timer = $Timer

@onready var parent:Node = get_node("..")

@export_group("state transitions")
##the idle state
@export var on_input_stopped: StateMachineState

##the movement state
@export var on_movement_detected: StateMachineState

##the attack state
@export var on_primary: StateMachineState

##the jump state
@export var on_jump_input: StateMachineState

##state for when the timer expires
@export var on_timer_expiration: StateMachineState

##for when the player turns around
@export var on_turn_around: StateMachineState

@export_group("animation")
##the name of the animation that this state will play
@export var main_animation:String

func setup(target: CharacterController):
	target.sprite.play(main_animation)
	timer.wait_time = time_till_heal
	parent = target
	timer.start()
	#add animation logic when animations exist
	
func step(target: CharacterController, delta):
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		target.jump()
			
	
	var previous_direction = target.current_direction
	# factor in player's intended movement
	target.computeActiveMovement(delta)
	target.update_facing_direction()
	var new_direction = target.current_direction
	if(new_direction != previous_direction):
		target.change_state(on_turn_around)
		timer.stop()
		return
	# actually move the character
	target.move_and_slide()
	print(timer.wait_time)
	# aftermath: after moving, decide on which states to change into
	if(Input.is_action_just_pressed("attack_primary")):
		#If attack AND move happened simultaneously, attack state will happen.
		target.change_state(on_primary)
		timer.stop()
		return
	if(not(target.is_on_floor()) and target.velocity.y > 0.1 * target.JUMP_VELOCITY):
		target.change_state(on_jump_input)
		timer.stop()
		return
	if target.activeMovement:
		target.change_state(on_movement_detected)
		timer.stop()
		return

func _on_timer_timeout():
	if(Input.is_action_pressed("player_shield_0")):
		parent.change_state(on_timer_expiration)
	else:
		parent.change_state(on_input_stopped)
	pass # Replace with function body.
