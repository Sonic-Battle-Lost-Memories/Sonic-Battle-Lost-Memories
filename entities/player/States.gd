extends Node

#name of the node that runs logic when the character is jumping
@export var jumping_state_name = "Jumping"

#name of the node that runs logic when the character is walking/jogging (do not mistake for dashing)
@export var walking_state_name = "Walking"

#name of the node that runs logic when the character is standing still on the floor.
@export var idle_state_name = "Idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
