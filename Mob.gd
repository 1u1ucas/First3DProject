extends KinematicBody

# Emitted when the player jumped on the mob.
signal squashed

# Minimum speed of the mob in meters per second.
export var min_speed = 10
# Maximum speed of the mob in meters per second.
export var max_speed = 18

var velocity = Vector3.ZERO
var start_position = Vector3()
var player_position = Vector3()

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func initialize(_start_position, _player_position):
	start_position = _start_position
	player_position = _player_position

func _ready():
	global_transform.origin = start_position
	
	# Calculate the direction towards the player
	var direction = (player_position - start_position).normalized()
	
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	direction = direction.rotated(Vector3.UP, rand_range(-PI / 4, PI / 4))

	# Calculate a random speed (integer)
	var random_speed = rand_range(min_speed, max_speed)
	# Calculate the velocity vector that represents the speed
	velocity = direction * random_speed

func squash():
	emit_signal("squashed")
	queue_free()

func _on_VisibilityNotifier_screen_exited():
	queue_free()
