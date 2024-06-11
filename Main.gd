extends Node

# Exported variable for the Mob scene
export (PackedScene) var mob_scene

# Function to handle mob spawning
func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene
	var mob = mob_scene.instance()

	# Choose a random location on the SpawnPath
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# Assign a random progress ratio to the SpawnLocation node
	mob_spawn_location.offset = randf()

	# Get the player's 
	var player_position = get_node("Player").translation
	# Initialize the mob with the spawn location and player's position
	mob.initialize(mob_spawn_location.translation, player_position)

	# Add the mob to the current scene
	add_child(mob)

# Function to handle player hit event
func _on_player_hit():
	# Stop the mob timer
	get_node("MobTimer").stop()
