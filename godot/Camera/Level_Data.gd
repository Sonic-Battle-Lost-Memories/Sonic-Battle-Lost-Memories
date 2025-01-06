extends Node
##stores all alive players
var players = []
var characters = []
var settings: Settings

func _ready():
	findNodesOfType(get_parent(), "CharacterBody3D", players)
	findMoreNodesOfType(get_parent(), "CharacterBody3D", characters)
#gets all nodes with character controller class, uses recursion but hopefully won't impact performance
func findNodesOfType(node: Node, className: String, result: Array):
	if node.is_class(className):
		if node is CharacterController:
			result.push_back(node)
			print(node.name + " has " + className)
	for child in node.get_children():
		findNodesOfType(child, className, result)
#lerps object pos why did I even make this it's own function
func lerpPos(lerpPosition: Vector3, lerpSpeed: float, delta: float, lerpObject: Node3D):
	lerp(lerpObject.global_position, lerpPosition, lerpSpeed * delta)
func findMoreNodesOfType(node: Node, className: String, result: Array):
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		findMoreNodesOfType(child, className, result)
