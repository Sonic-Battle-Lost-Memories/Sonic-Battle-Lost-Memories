extends Node

@onready var parent:Node = get_node("..")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called by the character controller only on the first frame of the state
func setup(target: CharacterController):
	target.sprite.play("run")
	pass

# Called by character controller on every frame where this this state is active.
func step(target: CharacterController, delta):
# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		target.jump()
		pass

	# factor in player's intended movement
	target.computeActiveMovement(delta)
	
	# actually move the character
	target.move_and_slide()
	
	# aftermath: change state if airborne or stopped
	if(not(target.is_on_floor())):
		target.change_state(parent.jumping_state_name)
	elif(not target.activeMovement):
		target.change_state(parent.idle_state_name)
	pass
