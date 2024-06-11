extends KinematicBody

export var bounce_impulse = 16
# Vitesse minimale du mob en mètres par seconde.
export var min_speed = 10
# Vitesse maximale du mob en mètres par seconde.
export var max_speed = 18

var velocity = Vector3.ZERO

signal squashed

func _ready():
	# Assurez-vous que le signal est connecté
	if not $VisibilityNotifier.is_connected("screen_exited", self, "_on_VisibilityNotifier_screen_exited"):
		var result = $VisibilityNotifier.connect("screen_exited", self, "_on_VisibilityNotifier_screen_exited")
		if result != OK:
			print("Failed to connect 'screen_exited' signal")

func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)

		if collision.collider and collision.collider.is_in_group("mob"):
			var mob = collision.collider
			if Vector3.UP.dot(collision.normal) > 0.1:
				if mob.has_method("squash"):
					mob.squash()
				velocity.y = bounce_impulse
				break

# Cette fonction sera appelée depuis la scène principale.
func initialize(start_position, player_translation):
	# Nous positionnons le mob en le plaçant à start_position
	global_transform.origin = start_position
	
	# et nous le faisons tourner vers player_translation, pour qu'il regarde le joueur.
	look_at(player_translation, Vector3.UP)
	
	# Faire tourner ce mob aléatoirement dans une plage de -45 à +45 degrés,
	# pour qu'il ne se déplace pas directement vers le joueur.
	rotate_y(rand_range(-PI / 4, PI / 4))
	
	# Nous calculons une vitesse aléatoire (entier)
	var random_speed = int(rand_range(min_speed, max_speed))
	
	# Nous calculons une vélocité avant qui représente la vitesse.
	velocity = Vector3.FORWARD * random_speed
	
	# Nous faisons ensuite tourner le vecteur de vélocité en fonction de la rotation Y du mob
	# pour qu'il se déplace dans la direction où le mob regarde.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_VisibilityNotifier_screen_exited():
	queue_free()

func squash():
	emit_signal("squashed")
	queue_free()
