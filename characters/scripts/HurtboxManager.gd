extends Node

@onready var Hurtboxes = $Hurtboxes
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Hurtboxes.global_position = get_parent().global_position
	pass
