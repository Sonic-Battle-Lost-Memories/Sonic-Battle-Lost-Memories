@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

##the health component of the player that manages health
@export var health_component: HealthComponent
##the idle state
@export var on_idle: StateMachineState
@export var main_animation: String
@export var on_gain_air: StateMachineState

@export var regenRate: float
func setup(target: CharacterController):
	target.sprite.play(main_animation)
	pass
	#add animation logic when animations exist
func step(target: CharacterController, delta):
	
	if health_component.currentHealth >= health_component.maxHealth:
		health_component.currentHealth = health_component.maxHealth
		#print("max health clipped!")
		target.change_state(on_idle)
	health_component.currentHealth += (1 * regenRate)
	print("new health is ", health_component.currentHealth)
	var previous_direction = target.current_direction
	
	if (not (Input.is_action_pressed("player_shield_0"))):
		target.change_state(on_idle)
	if (not(target.is_on_floor()) and target.velocity.y > 0.1 * target.JUMP_VELOCITY):
		target.change_state(on_gain_air)
		return
