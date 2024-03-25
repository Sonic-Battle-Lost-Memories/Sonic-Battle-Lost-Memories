extends Control

@onready var verticalContainers = [$VSplitContainer, $VSplitContainer2]
@onready var timeLabel = $Label
var progressbar: ProgressBar
var settings: LevelSettings
var seconds: int
var minutes: int
# Called when the node enters the scene tree for the first time.
func _ready():
	settings = get_parent().find_child("Settings")
	await get_tree().create_timer(.1).timeout
	
	var i = 0
	for player in Level.characters:
		print(player)
		print("CHR")
		if i >= len(verticalContainers): break

		verticalContainers[i].get_child(0).max_value = player.get_health_component().maxHealth
		verticalContainers[i].get_child(0).value = player.get_health_component().currentHealth
		verticalContainers[i].get_child(0).setPlayerHealthComp(player.get_health_component())
		verticalContainers[i].get_child(0).show()
		i += 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	seconds = int(fmod(settings.timer.time_left, 60))
	minutes = int(fmod(settings.timer.time_left, 60*60) / 60)
	var time = "%02d : %02d" % [minutes, seconds]
	timeLabel.text = time
	pass
