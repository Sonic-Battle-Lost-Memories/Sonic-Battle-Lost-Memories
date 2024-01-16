extends ProgressBar

var playerHealthComp: HealthComponent
@onready var playerLives = $PlayerLives
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setPlayerHealthComp(healthComp):
	playerHealthComp = healthComp
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if playerHealthComp != null:
		value = playerHealthComp.currentHealth
		playerLives.text = str(playerHealthComp.lives)
	pass
