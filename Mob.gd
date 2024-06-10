extends KinematicBody

# Minimum speed of the mob in meters per second.
export var min_speed = 10
# Maximum speed of the mob in meters per second.
export var max_speed = 18

var velocity = Vector3.ZERO

func _ready():
	# Ensure the signal is connected
	if not $VisibilityNotifier.is_connected("screen_exited", self, "_on_VisibilityNotifier_screen_exited"):
		$VisibilityNotifier.connect("screen_exited", self, "_on_VisibilityNotifier_screen_exited")

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

# This function will be called from the Main scene.
func initialize(start_position, player_translation):
	# We position the mob by placing it at start_position
	global_transform.origin = start_position
	
	# and rotate it towards player_translation, so it looks at the player.
	look_at(player_translation, Vector3.UP)
	
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(rand_range(-PI / 4, PI / 4))
	
	# We calculate a random speed (integer)
	var random_speed = int(rand_range(min_speed, max_speed))
	
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_VisibilityNotifier_screen_exited():
	queue_free()
