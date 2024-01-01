class_name LevelSettings
extends Node
@onready var timer = $Timer
@export var settings: Settings
# Called when the node enters the scene tree for the first time.
func _ready():
	Level.settings = settings
	timer.wait_time = settings.time
	for player in Level.players:
		player.healthComponent.lives = settings.lives
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
