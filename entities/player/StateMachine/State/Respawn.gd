@icon("res://dev_material/nerd_moji.png")
extends StateMachineState

@export var deathRay: RayCast3D
@export var deathCursor: Node3D
# Called when the node enters the scene tree for the first time.
func setup(target: CharacterController):
	target.collision.disabled = true
	target.sprite.hide()
	target.Shadow_not_the_Hedgehog.hide()
	deathCursor.show()
	pass
func step(_target: CharacterController, _delta):
	deathCursor.global_position = deathRay.get_collision_point()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
