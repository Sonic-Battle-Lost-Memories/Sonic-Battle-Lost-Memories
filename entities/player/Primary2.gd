extends Node

@onready var parent:Node = get_node("..")

#time since first frame of this state.
var time_elapsed: float = 0
@export var lifetime: float = 0.3

var allows_next_hit:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target: CharacterController):
	target.sprite.play("Primary2")
	print("entered p1 state")
	time_elapsed  = 0
	allows_next_hit = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
	time_elapsed += delta
	
	#slide the character to a stop if it was previously moving
	target.velocity.x = lerp(target.velocity.x, 0.0, 10 * delta)
	target.velocity.z = lerp(target.velocity.z, 0.0, 10 * delta)
	
	var is_time_for_next_hit = (time_elapsed > (lifetime - target.KEYPRESS_TIME_TOLERANCE))
	var is_triggering_next_hit = Input.is_action_pressed("attack_primary")
	if(is_time_for_next_hit and not is_triggering_next_hit):
		allows_next_hit = true
	if(allows_next_hit and is_triggering_next_hit):
		target.change_state(parent.primary3_state_name)
	
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
