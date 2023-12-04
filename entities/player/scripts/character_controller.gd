class_name CharacterController
extends CharacterBody3D

var SPEED = 16.0
var JUMP_VELOCITY = 18.0

@export var KEYPRESS_TIME_TOLERANCE = 1.250

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

# The movement caused by directional input by the player (usually joystick XY axis)
var activeMovement:Vector3 = Vector3(0,0,0)

var allowing_double_jump = false

@onready var sprite = $Sprite
@onready var camnode = $CamNode
@onready var camera = $CamNode/Camera
@onready var point = $Sprite/Point
@onready var stateTree = $States
@onready var current_state:StateMachineState = $States/Walking

func _ready():
	camnode.set_as_top_level(true)
#	if(is_on_floor):
#		current_state = stateTree.find_child("Jumping")
	

func _physics_process(delta):
	camera.look_at(point.global_position)
	#camnode.global_position.z = lerp(camnode.global_position.z, point.global_position.z, 2.5 * delta)
	camnode.global_position.z = point.global_position.z
	
	# Add the gravity.
	velocity.y -= gravity * delta
	current_state.step(self, delta)

func jump():
	velocity.y = JUMP_VELOCITY

func _on_area_3d_body_entered(body):
	if body.is_in_group("Entities"):
		if Input.is_action_pressed("attack_primary"):
			print("hola")
			#attack_timer.start()
			var direction = (body.transform.origin - global_transform.origin).normalized()
			body.velocity += Vector3(direction.x * 32, 0, direction.z * 32)

func change_state(next_state:StateMachineState):
	print("changed state to", next_state.name)
	current_state = next_state
	current_state.setup(self)

# filters player directional movement input into normalized xz axis speed.
func computeActiveMovement(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	activeMovement = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if activeMovement:
		velocity.x = lerp(velocity.x, activeMovement.x * SPEED, 6.5 * delta)
		velocity.z = lerp(velocity.z, activeMovement.z * SPEED, 6.5 * delta)
		sprite.rotation.y = atan2(velocity.x, velocity.z)
	else:
		velocity.x = lerp(velocity.x, 0.0, 10 * delta)
		velocity.z = lerp(velocity.z, 0.0, 10 * delta)
	
	if activeMovement.x <= -0.5:
		sprite.flip_h = true
	elif activeMovement.x >= 0.5:
		sprite.flip_h = false

