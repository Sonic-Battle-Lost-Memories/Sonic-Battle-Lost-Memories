extends CharacterBody3D

@onready var sprite: AnimatedSprite3D = $sprite

@export var SPEED = 5.0
@export var FALL_RATE = 0.8

@export var lifetime: float

var initial_velocity: Vector3

var blame: CharacterController



@onready var time_elapsed: float = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	match blame.active_movement_discrete:
		blame.discrete_movement_direction.RIGHT:
			if (blame.is_on_floor()):
				self.sprite.play("ground right")
			else:
				self.sprite.play("air right")
			pass
		blame.discrete_movement_direction.LEFT:
			sprite.flip_h = true
			if (blame.is_on_floor()):
				self.sprite.play("ground right")
			else:
				self.sprite.play("air right")
			pass
		blame.discrete_movement_direction.TOP:
			if (blame.is_on_floor()):
				self.sprite.play("ground up")
			else:
				self.sprite.play("air up")
			pass
		blame.discrete_movement_direction.BOTTOM:
			if (blame.is_on_floor()):
				self.sprite.play("ground down")
			else:
				self.sprite.play("air down")
			pass
func setup(initial_position: Vector3, owner: CharacterController, direction: Vector3):
	position = initial_position
	blame = owner

	if(direction.length() < 0.91):
		velocity = Vector3(1,0,0) * SPEED
		if(owner.current_direction != owner.facing_direction.RIGHT):
			velocity.x *= -1.0
	else:
		velocity = (direction * SPEED)
	
	velocity.y = -1 * (SPEED * FALL_RATE)
	
	
	initial_velocity = velocity
	
	pass

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		velocity.y = 0

	move_and_slide()
	
	time_elapsed += delta
	if(time_elapsed > lifetime):
		queue_free()
	
	#if((initial_velocity.normalized().dot(velocity.normalized())) < 0.3 or velocity.length() < 0.7 * SPEED):
	#	queue_free()
