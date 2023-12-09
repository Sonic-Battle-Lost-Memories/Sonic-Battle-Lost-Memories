@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

# time since this state started
var time_elapsed:float = 0.0

# booleans for double-jump logic
var can_double_jump:bool = false

@onready var parent: Node = get_node("..")

@export_group("state trasitions")
@export var on_grounded: StateMachineState
@export var on_primary: StateMachineState
@export var on_double_jump: StateMachineState

@export_group("action parameters")
@export var time_till_air_action: float

@export_group("animation")

@export var main_animation: String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target:CharacterController):
	target.sprite.play(main_animation)

	#print("double jump allowed in ", time_till_air_attack, "s")
	time_elapsed = 0
	can_double_jump = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	# Double jump: only happens once in the whole contiguous air time.
	if (not can_double_jump) and (not Input.is_action_just_pressed("jump")):
		can_double_jump = true
		print("ready to double jump")
		pass
	if (can_double_jump) and (target.allowing_double_jump) and (Input.is_action_just_pressed("jump")):
		target.change_state(on_double_jump)
		print("double jumped")
		return
	
	if(Input.is_action_just_pressed("attack_primary") and time_elapsed > time_till_air_action):
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
