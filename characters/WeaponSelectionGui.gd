extends Control


@export var seletionBox : TextureRect
var selection = 0
var lastInput = false
var available = false
func _ready():
	pass


func _process(delta):
	if visible and available:
		if selection < 0:
			selection = 3
		
		if Input.is_key_pressed(KEY_D):
			AddSelection(1)
		elif Input.is_key_pressed(KEY_A):
			AddSelection(-1)
		elif lastInput:
			lastInput = false
		seletionBox.position = Vector2(7,22) + Vector2(selection%3*42,0)
	
		if Input.is_key_pressed(KEY_ENTER):
			print("selected "+str(selection))
			available = false
	else: hide()
func AddSelection(move : int):
	if not lastInput:
		selection += move
		lastInput = true
