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
	for player in Level.characters:
		print(player)
		var i = 0
		var j = 0
		if i == j:
			#progressbar.max_value
			verticalContainers[0].get_child(i).max_value = player.get_health_component().maxHealth
			verticalContainers[0].get_child(i).value = player.get_health_component().currentHealth
			verticalContainers[0].get_child(i).setPlayerHealthComp(player.get_health_component())
			verticalContainers[0].get_child(i).show()
			i+=1
		if i != j: 
			verticalContainers[1].get_child(j).max_value = player.get_health_component().maxHealth
			verticalContainers[1].get_child(j).value = player.get_health_component().currentHealth
			verticalContainers[1].get_child(j).setPlayerHealthComp(player.get_health_component())
			verticalContainers[1].get_child(j).show()
			j+=1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	seconds = int(fmod(settings.timer.time_left, 60))
	minutes = int(fmod(settings.timer.time_left, 60*60) / 60)
	var time = "%02d : %02d" % [minutes, seconds]
	timeLabel.text = time
	pass
