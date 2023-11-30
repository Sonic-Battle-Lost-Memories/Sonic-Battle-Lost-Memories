extends Node

# Called every frame. 'delta' is the eextends Node

@onready var parent:Node = get_node("..")

#time since first frame of this state.
var time_elapsed: float = 0
@export var lifetime: float = 0.7

var allows_next_hit:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target: CharacterController):
	target.sprite.play("Primary4")
	time_elapsed  = 0
	allows_next_hit = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	#slide the character to a stop if it was previously moving
	target.velocity.x = lerp(target.velocity.x, 0.0, 10 * delta)
	target.velocity.z = lerp(target.velocity.z, 0.0, 10 * delta)

	
	target.move_and_slide()
	
	if (time_elapsed > lifetime):
		if(not target.is_on_floor()):
			target.change_state(parent.jumping_state_name)
			return
		target.computeActiveMovement(delta)
		if(target.activeMovement):
			target.change_state(parent.walking_state_name)
			return
		else:
			target.change_state(parent.idle_state_name)
			return
func _process(delta):
	pass
