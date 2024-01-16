extends Node3D
##determines how far away the camera is from the player
@export var distance_from_player = 5.0
#the camera node itself
@onready var camera = $Camera3D
##Node that detects the center between 2 or more players
@export var CenterPoint = Node3D
##Maximum angle the camera can rotate in Degrees
@export var clampAngle = 15
##How far away the camera can get from the Pivot
@export var camDistance = 5
##How fast the camera catches up to the player
@export var camera_speed = 5
##The offset on the Y axis for looking at the playe
@export var y_offset = 5

# Sets the camera  node to top level
func _ready():
	
	
	camera.top_level = true


func _process(delta):
	#logic for multiplayer on same system
	if(Level.players.size() > 1):
		global_position = calculateAveragePosition()
		global_position.y = calculateAveragePosition().y + y_offset
		calculateCameraRotation(delta)
		rotation = Vector3(0,clamp(-rotation.y,deg_to_rad(-clampAngle),deg_to_rad(clampAngle)),0)
		camera.position.z = position.z + 30
		camera.position.x = lerp(camera.position.x, position.x, 10 * delta)
		camera.position.x = clamp(camera.position.x, -camDistance, camDistance)
		camera.size = calculatePlayerDistance() + distance_from_player
		camera.look_at(global_position, transform.basis.y)
	#Logic for when there is only one player on system
	elif Level.players.size() == 1:
		global_position = Level.players[0].pivot.global_position
		global_position.y = Level.players[0].pivot.global_position.y + y_offset
		camera.look_at(Level.players[0].pivot.global_position, transform.basis.y)
		camera.size = distance_from_player
		camera.position.z = lerp(camera.position.z, position.z + 30, 10 * delta)
		camera.position.x = lerp(camera.position.x, position.x, 10 * delta)
		camera.position.x = clamp(camera.position.x, -camDistance, camDistance)
		camera.position.y = lerp(camera.position.y, position.y, 10 * delta)
	pass
func calculateAveragePosition():
	#does math to get the average position between all players
	var average = Vector3.ZERO
	if Level.players.size() > 1:
		for player in Level.players:
			average += player.global_position
		return average/Level.players.size()
	else:
		return Level.players[0].global_position
	
func calculatePlayerDistance():
	#calculates how far the camera should be from the center point to best frame action
	var maxDistance = 0.0
	for player in Level.players:
		var distance = player.pivot.position.distance_to(position)
		if distance > maxDistance:
			maxDistance = distance
	return maxDistance
func calculateCameraRotation(delta):
	#calculates camera rotation
	var T=global_transform.looking_at(CenterPoint.global_transform.origin, Vector3(0,1,0))
	global_transform.basis.y=lerp(global_transform.basis.y, T.basis.y, delta*camera_speed)

