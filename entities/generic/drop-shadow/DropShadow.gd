extends Sprite3D

var initialized = false

@onready var ShadowCast = get_node("./ShadowCast")
@onready var ShadowOwner = get_parent()

#var counter = Timer.new()
#var dir = 1

#func _ready():
#	add_child(counter)
#	counter.set_one_shot(true)
#	counter.set_wait_time(10.0)
#	counter.start()

#func _physics_process(_delta):
#	if counter.get_time_left()!=0:
#		ShadowOwner.global_position.y+=.01*dir
#		#print(counter.get_time_left())
#	else:
#		dir = dir*-1
#		counter.set_wait_time(10.0)
#		counter.start()

func _process(_delta):
	if !initialized:
		ShadowCast.reparent(ShadowOwner)
		if ShadowOwner.is_class("CollisionObject3D"):
			ShadowCast.add_exception(ShadowOwner)
		initialized = true
	# Sets location of sprite and adjusts for frame by frame offset caused by moving the parent object.
	ShadowCast.target_position=(ShadowOwner.global_position+Vector3(0,1,0))*Vector3(0,-10,0)
	global_position = ShadowCast.get_collision_point()+Vector3(0,0.0001,0)
	#animates frame of shadow based on height
	if global_position.distance_to(ShadowOwner.global_position)>1 && global_position.distance_to(ShadowOwner.global_position)<2:
		frame = 1
	elif global_position.distance_to(ShadowOwner.global_position)>2:
		frame = 2
	else:
		frame = 0
