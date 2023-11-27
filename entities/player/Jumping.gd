extends Node

var elapsed:float = 0.0
var can_double_jump:bool = false
var did_double_jump:bool = false
var standing_still:bool = false

@onready var parent:Node = get_node("..")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(target:CharacterController):
	target.sprite.play("jump")
	did_double_jump = false
	can_double_jump = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func step(target: CharacterController, delta):
# Handle Jump.
	if (not did_double_jump) and (not can_double_jump) and (not Input.is_action_just_pressed("jump")) and elapsed > 0.08:
		can_double_jump = true
		print("ready to double jump")
		pass
	if (can_double_jump) and (Input.is_action_just_pressed("jump")):
		target.jump()
		print("double jumped")
		did_double_jump = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (target.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		target.velocity.x = lerp(target.velocity.x, direction.x * target.SPEED, 10.5 * delta)
		target.velocity.z = lerp(target.velocity.z, direction.z * target.SPEED, 10.5 * delta)
		target.sprite.rotation.y = atan2(target.velocity.x, target.velocity.z)
	else:
		target.velocity.x = lerp(target.velocity.x, 0.0, 10 * delta)
		target.velocity.z = lerp(target.velocity.z, 0.0, 10 * delta)
		
	
	#if velocity.y >= 0:
		#sprite.animation = "jump"
	
	if direction.x <= -0.5:
		target.sprite.flip_h = true
	elif direction.x >= 0.5:
		target.sprite.flip_h = false
	
	target.move_and_slide()
	if(target.is_on_floor()):
		target.change_state(parent.walking_state_name)
		
	elapsed += delta
	pass
