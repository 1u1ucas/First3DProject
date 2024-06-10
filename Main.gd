extends Node

export var mob_scene: PackedScene

func _ready():
	# Check if the signal is already connected to avoid duplicate connections
	if not $MobTimer.is_connected("timeout", self, "_on_MobTimer_timeout"):
		var timer_connected = $MobTimer.connect("timeout", self, "_on_MobTimer_timeout")
		if timer_connected != OK:
			print("Failed to connect MobTimer timeout signal")

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	if mob_scene:
		var mob = mob_scene.instance()

		# Choose a random location on the SpawnPath.
		var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
		
		# Check if mob_spawn_location is valid
		if mob_spawn_location:
			# And give it a random offset along the path.
			mob_spawn_location.unit_offset = randf()

			# Get the position from the PathFollow node.
			var spawn_position = mob_spawn_location.translation

			var player_translation = $Player.translation

			# Spawn the mob by adding it to the Main scene first.
			add_child(mob)

			# Initialize the mob with the correct position and player translation
			# Using call_deferred to ensure it is properly inside the tree
			mob.call_deferred("initialize", spawn_position, player_translation)
		else:
			print("SpawnLocation node not found")
	else:
		print("mob_scene is not assigned")
