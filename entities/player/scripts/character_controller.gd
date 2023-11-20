extends CharacterBody3D

var SPEED = 9.0
var JUMP_VELOCITY = 16.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

@onready var sprite = $Sprite
@onready var camnode = $CamNode
@onready var camera = $CamNode/Camera
@onready var point = $Sprite/Point

func _ready():
	camnode.set_as_top_level(true)

func _physics_process(delta):
	camera.look_at(point.global_position)
	#camnode.global_position.z = lerp(camnode.global_position.z, point.global_position.z, 2.5 * delta)
	camnode.global_position.z = point.global_position.z
	
	# Add the gravity.
	velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, 10.5 * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED, 10.5 * delta)
		sprite.rotation.y = atan2(velocity.x, velocity.z)
		if is_on_floor():
			sprite.animation = "run"
	else:
		velocity.x = lerp(velocity.x, 0.0, 10 * delta)
		velocity.z = lerp(velocity.z, 0.0, 10 * delta)
		if is_on_floor():
			sprite.animation = "idle"
	
	#if velocity.y >= 0:
		#sprite.animation = "jump"
	
	if direction.x <= -0.5:
		sprite.flip_h = true
	elif direction.x >= 0.5:
		sprite.flip_h = false
	
	move_and_slide()
	
func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
