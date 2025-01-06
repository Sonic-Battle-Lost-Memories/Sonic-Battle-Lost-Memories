class_name Battle_Settings
extends Node

@export var saveName: String = "Default"
@export var items = {"Ring Capsule": true, "Bomb": true, "Chaos Emerald": true}

@export var minutes: int = 5
@export var seconds: int = 30
enum stage_mode{SELECT,P1ONLY,LOSERSPICK,INORDER,RANDOM}
@export var s_mode:stage_mode = stage_mode.SELECT

# Called when the node enters the scene tree for the first time.
func _ready():
	var directory:DirAccess = DirAccess.open("user://")
	var dir_path = "user://Saves/Settings"
	if !directory.dir_exists(dir_path):
		directory.make_dir("user://Saves")
		directory.make_dir("user://Saves/Settings")
	save()
func save():
	var file = FileAccess.open("user://Saves/Settings/Settings_" + saveName + ".hedgehog", FileAccess.WRITE)
	print(file.get_path())
	for item in items: #items get saved before anything else
		file.store_var(items[item])
	file.store_var(minutes)
	file.store_var(seconds)
	file.store_var(s_mode)
func load():
	pass
