extends CharacterBody3D

var SPEED = 9.0
var JUMP_VELOCITY = 16.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

@onready var agent = $NavigationAgent3D
@onready var sprite = $Sprite
@onready var entity_detect = $Area3D
@onready var attack_timer = $AttackTimer
@export var target: Node
@export var is_offense = false

func _process(delta):
	if target:
		agent.set_target_position(target.global_transform.origin)
		var next_point = agent.get_next_path_position()
		var direction = (global_transform.basis * velocity).normalized()
		var point = (next_point - global_transform.origin).normalized()
		#velocity = (next_point - global_transform.origin).normalized() * SPEED
		#velocity = (next_point - global_transform.origin).normalized() * SPEED
		#velocity = lerp(velocity, point * SPEED, 10.5 * delta)
		
		velocity.x = lerp(velocity.x, point.x * SPEED, 10.5 * delta)
		velocity.z = lerp(velocity.z, point.z * SPEED, 10.5 * delta)
		
		rotation.y = atan2(velocity.x, velocity.z)
		
		if direction:
			if is_on_floor():
				sprite.animation = "run"
		else:
			if is_on_floor():
				sprite.animation = "idle"
		

func _physics_process(delta):
	# Add the gravity.
	velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (global_transform.basis * velocity).normalized()
	#if direction:
	#	velocity.x = lerp(velocity.x, direction.x * SPEED, 10.5 * delta)
	#	velocity.z = lerp(velocity.z, direction.z * SPEED, 10.5 * delta)
		#if is_on_floor():
		#	sprite.animation = "run"
	#else:
	#	velocity.x = lerp(velocity.x, 0.0, 10 * delta)
	#	velocity.z = lerp(velocity.z, 0.0, 10 * delta)
		#if is_on_floor():
		#	sprite.animation = "idle"
	
	#if velocity.y >= 0:
		#sprite.animation = "jump"
	
	if direction.x <= -0.5:
		sprite.flip_h = true
	elif direction.x >= 0.5:
		sprite.flip_h = false
	
	move_and_slide()
	

func _on_area_3d_body_entered(body):
	#if attack_timer.is_stopped():
	#	attack_timer.start()
	#	print("hola")
	
	if body.is_in_group("Entities"):
		if is_offense:
			print("hola")
			var direction = (body.transform.origin - global_transform.origin).normalized()
			body.velocity += Vector3(direction.x * 32, direction.y + 8, direction.z * 32)
	
#	if is_offense:
		if body.is_in_group("Entities"):
			if attack_timer.is_stopped():
				attack_timer.start()
				print("hola")
