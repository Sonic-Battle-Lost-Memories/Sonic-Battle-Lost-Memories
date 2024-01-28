class_name Battle_Settings
extends Node

@export var items = {"Ring Capsule": true, "Bomb": true}
@export var saveName: String
@export var minutes: int
@export var seconds: int

# Called when the node enters the scene tree for the first time.

func _ready():
	save()
func save():
	var file = FileAccess.open("user://Settings_" + saveName + ".hedgehog", FileAccess.WRITE)
	print(file.get_path())
	for item in items: #items get saved before anything else
		file.store_var(items[item])
	file.store_var(minutes)
	file.store_var(seconds)
