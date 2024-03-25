class_name CharacterController
extends CharacterBody3D

var SPEED = 16.0
var ACCELERATION = 6.5
var JUMP_VELOCITY = 18.0

# to check if there is a trap already on the field
var has_trap = false

enum facing_direction {RIGHT, LEFT} 

@export var KEYPRESS_TIME_TOLERANCE = 1.250

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

# The movement caused by directional input by the player (usually joystick XY axis)
var activeMovement:Vector3 = Vector3(0,0,0)

enum discrete_movement_direction {LEFT, RIGHT, TOP, BOTTOM}
@onready var active_movement_discrete = discrete_movement_direction.RIGHT

var hitCount = 0
var allowing_double_jump = false

var sling = false

var sprite: AnimatedSprite3D
var point: Node3D
@export var characterData: CharacterData
@onready var stateTree = $States
@onready var healthComponent = $HealthComponent
@onready var collision = $CollisionShape3D
var Sprite
@onready var Shadow_not_the_Hedgehog = $DropShadow
@export var current_state: StateMachineState
@onready var respawn = $States/StateMachineState/Health/Respawn
@onready var pivot = $CameraPivot
var respawning = false
@onready var current_direction: facing_direction = facing_direction.RIGHT
@onready var parent: Node3D = $".."
var input_dir: Vector2

var bodys = []

func _ready():
	pivot.top_level = true
	var player = characterData.Sprite.instantiate()
	add_child(player)
	
	player.connect("animation_finished",animation_finished)
	point = player.get_node("Point")
	sprite = player
	Sprite = player
	SPEED = characterData.maxSpeed
	ACCELERATION = characterData.acceleration
	pass
#	if(is_on_floor):
#		current_state = stateTree.find_child("Jumping")
func animation_finished():
	pass

func _physics_process(delta):
	#look_at(point.global_position)
	#camnode.global_position.z = lerp(camnode.global_position.z, point.global_position.z, 2.5 * delta)
	if point == null:
		return
	if is_on_floor() and sling:
		sling = false
		#velocity = Vector3(0,0,0)
	
	global_position.z = point.global_position.z
	
	if healthComponent.currentHealth <= 0:
		respawn.setup(self)
		if not respawning:
			healthComponent.lives -= 1

		respawning = true
		pivot.global_position = respawn.deathCursor.global_position
		lerp(pivot.global_position, respawn.deathCursor.global_position, 10 * delta)
		respawn.step(self, delta)
		pass
	
	if respawning:
		if Input.is_action_just_released("respawn"):
			respawning = false
			healthComponent.currentHealth = healthComponent.maxHealth
			respawn.stop(self)
	# Add the gravity.
	else:
		velocity.y -= gravity * delta
		pivot.global_position = global_position
		lerp(pivot.global_position, global_position, 10 * delta)
	current_state.step(self, delta)


func jump():
	if not respawning:
		velocity.y = JUMP_VELOCITY


func change_state(next_state:StateMachineState):
	#print("changed state to ", next_state.name)
	if(next_state.state_enabled):
		current_state = next_state
		current_state.setup(self)
	pass


# filters player directional movement input into normalized xz axis speed.
func computeActiveMovement(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("left", "right", "up", "down")
	activeMovement = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if activeMovement:
		velocity.x = lerp(velocity.x, activeMovement.x * SPEED,ACCELERATION  * delta)
		velocity.z = lerp(velocity.z, activeMovement.z * SPEED,ACCELERATION  * delta)
		sprite.rotation.y = atan2(velocity.x, velocity.z)
	return

func update_facing_direction():
	if activeMovement.x <= -0.5:
		current_direction = facing_direction.LEFT
		sprite.flip_h = true
		active_movement_discrete = discrete_movement_direction.LEFT
	elif activeMovement.x >= 0.5:
		current_direction = facing_direction.RIGHT
		sprite.flip_h = false
		active_movement_discrete = discrete_movement_direction.RIGHT
	if activeMovement.z <= -0.5:
		active_movement_discrete = discrete_movement_direction.TOP
	elif activeMovement.z >= 0.5:
		active_movement_discrete = discrete_movement_direction.BOTTOM
	return
func get_health_component() -> HealthComponent:
	return healthComponent

signal trap_triggered()


func attack_primary():
	#if Input.is_action_pressed("attack_primary"):
		if len(bodys) > 0 and hitCount < 3:
			var body = bodys[0] # TODO: change target
			body.cooldown = 0.15
			body.healthComponent.currentHealth -= hitCount%3*5+5
			var direction = (body.transform.origin - global_transform.origin).normalized()
			body.velocity += Vector3(direction.x * 32, 0, direction.z * 32)

func _on_area_3d_area_entered(area):
	var body = area.get_parent_node_3d()
	if body.is_in_group("Entities"):
		bodys += [body]
	
		
		#attack_timer.start()

func _on_area_3d_area_exited(area):
	var body = area.get_parent_node_3d()
	if bodys.has(body):
		bodys.erase(body)
