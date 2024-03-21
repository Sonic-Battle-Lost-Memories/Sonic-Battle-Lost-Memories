extends Spawnable
class_name Bomb_sonic

@onready var counter: float = 0
@export var sprite: AnimatedSprite3D
@export var setup_time: float
@export var timeout: float
@export var timed: bool

var spawned = true
enum stage {SETTING, ACTIVE}
var current_stage: stage

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("idle")
	print("spawned bomb, t0 ")
	if(timed):
		print("it blows in ", timeout, " seconds.")
	pass # Replace with function body.

func set_down(pos:Vector3, trigger: Signal):
	position = pos
	current_stage = stage.SETTING
	pass
func spawn(pos: Vector3, trigger: Signal):
	position = pos
	current_stage = stage.ACTIVE
	trigger.connect(explode)
	pass
	
func explode():
	print('Bomb blew up!')
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_stage:
		stage.SETTING:
			
			pass
		stage.ACTIVE:
			
			pass
	counter += delta
	if counter >= timeout and timed:
		explode()
		queue_free()
	pass




func _on_area_3d_area_entered(area):
	if not spawned:
		var body = area.get_parent()
		print("entered")
		if body.is_in_group("Entities"):
			print("explode")
			sprite.play("explode")
			body.healthComponent.currentHealth -= 10
			body.velocity = Vector3(0,15,0)
			body.sling = true
			quee_free()
			#TODO: Play animation
			
	else:
		spawned = false

func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("shape") # Replace with function body.


func _on_sprite_bomb_animation_finished():
	
	if sprite.animation	== "explode":
		queue_free() # Replace with function body.
