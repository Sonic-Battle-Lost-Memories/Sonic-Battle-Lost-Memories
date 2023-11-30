extends Node

#name of the node that runs logic when the character is jumping
@export var jumping_state_name = "Jumping"

#name of the node that runs logic when the character is walking/jogging (do not mistake for dashing)
@export var walking_state_name = "Walking"

#name of the node that runs logic when the character is standing still on the floor.
@export var idle_state_name = "Idle"

#Primary attack, first hit
@export var primary1_state_name = "Primary1"

#primary attack, second hit
@export var primary2_state_name = "Primary2"

#primary attack, third hit
@export var primary3_state_name = "Primary3"

#primary attack, fourth hit
@export var primary4_state_name = "Primary4"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
