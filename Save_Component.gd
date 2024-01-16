extends Node

var items = {"Ring Capsule": 0, "active": true}
@export var saveName: String
# Called when the node enters the scene tree for the first time.

func _ready():
	var i = 0
	save()
func save():
	var file = FileAccess.open("user://Settings_" + saveName + ".hedgehog", FileAccess.WRITE)
	print(file.get_path())
	for item in items:
		if items
