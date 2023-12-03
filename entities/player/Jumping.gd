extends StateMachineState

# time since this state started
var elapsed:float = 0.0

# booleans for double-jump logic
var can_double_jump:bool = false
var did_double_jump:bool = false

@onready var parent: Node = get_node("..")

@export var on_grounded: StateMachineState
@export var on_primary: StateMachineState
@export var time_till_air_attack: float
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target:CharacterController):
	target.sprite.play("jump")
	did_double_jump = false
	can_double_jump = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	elapsed += delta
	
	# Double jump: only happens once and only allowed after a minimum air time.
	if (not can_double_jump) and (not Input.is_action_just_pressed("jump")) and elapsed > 0.08:
		can_double_jump = true
		print("ready to double jump")
		pass
	if (can_double_jump) and (not did_double_jump)and (Input.is_action_just_pressed("jump")):
		target.jump()
		print("double jumped")
		did_double_jump = true
	
	if(Input.is_action_just_pressed("attack_primary")):
		target.change_state(on_primary)
		return
	
	# factor in player's intended movement
	target.computeActiveMovement(delta)
	
	# actually move the character
	target.move_and_slide()
	
	# aftermath: change state if landed
	if(target.is_on_floor()):
		# you'll probably want a "landing" state here.
		target.change_state(on_grounded)

	pass
