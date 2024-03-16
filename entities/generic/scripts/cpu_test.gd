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
@onready var healthComponent = $HealthComponent

var bodys = []

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
		
		if is_offense and len(bodys) > 0:
			attack_primary()
			sprite.animation = "run"
		elif direction:
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

func attack_primary():
	print("entity detected!")
	if is_offense and len(bodys) > 0:
		print("hola")
		
		var body = bodys[0] # TODO: change the selection of which target get attacked!
			#attack_timer.start()
		var direction = (body.transform.origin - global_transform.origin).normalized()
		body.velocity += Vector3(direction.x * 32, 0, direction.z * 32)

func get_health_component() -> HealthComponent:
	return healthComponent


func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Area entered! CPU")

	



func _on_area_3d_area_entered(area):
	var body = area.get_parent() # gets the body of the detected object
	if body.is_in_group("Entities"):
		bodys += [body]


func _on_area_3d_area_exited(area):
	var body = area.get_parent_node_3d()
	if bodys.has(body):
		bodys.erase(body)
