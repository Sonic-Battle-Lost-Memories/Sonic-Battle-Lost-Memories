@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

@onready var parent:Node = get_node("..")

var time_elapsed = 0.0

@export_group("state transitions")
@export var time_till_bored = 0.85
@export var on_primary: StateMachineState
@export var on_moved: StateMachineState
@export var on_gained_air: StateMachineState
@export var on_jumped: StateMachineState
@export var on_turn_around: StateMachineState
@export var on_shield: StateMachineState
@export var on_debug_new_action: StateMachineState

@export var cycles_names: Array[String] = ["idle", "idle2"]
var current_cycle: int = 0
var got_bored: bool = false
var bored_over: bool = false
var last_known_facing_direction



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target: CharacterController):
	time_elapsed = 0.0
	got_bored = false
	bored_over = false
	current_cycle = 0
	target.sprite.play(cycles_names[current_cycle])
	
	target.allowing_double_jump = true
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		target.jump()
	if(Input.is_action_just_pressed("player_shield_0")):
		if(target.velocity.x == 0 and target.velocity.z == 0 and target.velocity.y >= 0):
			target.input_dir = Vector2.ZERO
			lerp(target.velocity, Vector3.ZERO, 10 * delta)
		else:
			target.change_state(on_shield)
	var previous_direction = target.current_direction
	# factor in player's intended movement
	target.computeActiveMovement(delta)
	target.update_facing_direction()
	var new_direction = target.current_direction
	if(new_direction != previous_direction):
		target.change_state(on_turn_around)
		return
	if(time_elapsed > time_till_bored):
		if(not got_bored):
			got_bored = true
			current_cycle = 1
			target.sprite.play(cycles_names[current_cycle])
		if(target.sprite.frame > 41):
			target.sprite.play("idle")
		pass
	# actually move the character
	target.move_and_slide()
	if(Input.is_action_just_pressed("player_shield_0")):
		if(target.velocity != Vector3.ZERO):
			lerp(target.velocity, Vector3.ZERO, 10 * delta)
	# aftermath: after moving, decide on which states to change into
	if(Input.is_action_just_pressed("debug_new_action")):
		target.trap_triggered.emit()
		target.change_state(on_debug_new_action)
	if(Input.is_action_just_pressed("attack_primary")):
		#If attack AND move happened simultaneously, attack state will happen.
		target.change_state(on_primary)
		return
	if(not(target.is_on_floor())):
		target.change_state(on_gained_air)
	#	target.change_state(on_jumped)
		#return
	if target.activeMovement:
		target.change_state(on_moved)
		return
	pass
