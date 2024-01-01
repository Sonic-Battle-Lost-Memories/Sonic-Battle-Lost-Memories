@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

##the health component of the player that manages health
@export var health_component: HealthComponent
##the idle state
@export var on_idle: StateMachineState
@export var on_walk_input: StateMachineState
@export var on_turn_around: StateMachineState
@export var on_jump:StateMachineState
@export var on_primary: StateMachineState

@export var regenRate: float
func setup(_target: CharacterController):
	pass
	#add animation logic when animations exist
func step(target: CharacterController, delta):
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		target.jump()
	
	if health_component.currentHealth >=health_component.maxHealth:
		health_component.currentHealth = health_component.maxHealth
		target.change_state(on_idle)
	health_component.currentHealth += (1 * regenRate)
	var previous_direction = target.current_direction
	# factor in player's intended movement
	target.computeActiveMovement(delta)
	target.update_facing_direction()
	var new_direction = target.current_direction
	if(new_direction != previous_direction):
		target.change_state(on_turn_around)
		return
	# actually move the character
	target.move_and_slide()
	# aftermath: after moving, decide on which states to change into
	if(Input.is_action_just_pressed("attack_primary")):
		#If attack AND move happened simultaneously, attack state will happen.
		target.change_state(on_primary)
		return
	if(not(target.is_on_floor()) and target.velocity.y > 0.1 * target.JUMP_VELOCITY):
		target.change_state(on_jump)
		return
	if target.activeMovement:
		target.change_state(on_walk_input)
		return
