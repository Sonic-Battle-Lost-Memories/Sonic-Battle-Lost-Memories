extends Node3D

@onready var counter: float = 0
@export var sprite: AnimatedSprite3D
@export var setup_time: float
@export var timeout: float

enum stage {SETTING, ACTIVE}
var current_stage: stage

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("idle")
	print("spawned bomb, t0 ", counter, ", it blows in ", timeout, " seconds.")
	pass # Replace with function body.

func set_down(pos:Vector3, trigger: Signal):
	position = pos
	current_stage = stage.SETTING
	pass
func spawn(pos: Vector3, trigger: Signal):
	position = pos
	current_stage = stage.ACTIVE
	trigger.connect(explode)
	pass
	
func explode():
	print('Bomb blew up!')
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match current_stage:
		stage.SETTING:
			
			pass
		stage.ACTIVE:
			
			pass
	counter += delta
	if counter >= timeout:
		explode()
		queue_free()
	pass
