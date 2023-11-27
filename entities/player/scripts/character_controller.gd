class_name CharacterController
extends CharacterBody3D

var SPEED = 9.0
var JUMP_VELOCITY = 16.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

@onready var sprite = $Sprite
@onready var camnode = $CamNode
@onready var camera = $CamNode/Camera
@onready var point = $Sprite/Point
@onready var stateTree = $States
@onready var current_state = $States/Walking

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
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

func _on_area_3d_body_entered(body):
	if body.is_in_group("Entities"):
		if Input.is_action_pressed("attack_primary"):
			print("hola")
			#attack_timer.start()
			var direction = (body.transform.origin - global_transform.origin).normalized()
			body.velocity += Vector3(direction.x * 32, 0, direction.z * 32)

func change_state(stateName:String):
	current_state = stateTree.find_child(stateName)
	print("changed state to", stateName)
	current_state.setup(self)

