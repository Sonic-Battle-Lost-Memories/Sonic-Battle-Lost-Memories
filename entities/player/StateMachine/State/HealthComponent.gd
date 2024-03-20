class_name HealthComponent
extends Node

##defines maximum health value
@export var maxHealth: float
##how many lives the player has
@export var lives: int
#current health value
var currentHealth: float
var player: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	maxHealth = 100
	player = get_parent()
	currentHealth = maxHealth
	await get_tree().create_timer(.1).timeout
	lives = Level.settings.lives
	print("lives: " + str(lives))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug_health_f1"):
		currentHealth -= 10
		print(currentHealth)
	elif Input.is_action_just_pressed("debug_kill_f2"):
		currentHealth = 0
		print("I've got you now hedgehog")
	pass
