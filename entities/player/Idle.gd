extends Node

@onready var parent:Node = get_node("..")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target: CharacterController):
	target.sprite.play("idle")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		target.jump()
	
	# factor in player's intended movement
	target.computeActiveMovement(delta)
	
	# actually move the character
	target.move_and_slide()
	
	# aftermath: after moving, decide on which states to change into
	if(Input.is_action_just_pressed("attack_primary")):
		#If attack AND move happened simultaneously, attack state will happen.
		target.change_state(parent.primary1_state_name)
		return
	if(not(target.is_on_floor()) and target.velocity.y > 0.1 * target.JUMP_VELOCITY):
		target.change_state(parent.jumping_state_name)
		return
	if target.activeMovement:
		target.change_state(parent.walking_state_name)
		return
	pass
