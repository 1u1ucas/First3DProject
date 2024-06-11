extends KinematicBody

export var speed = 14
export var fall_acceleration = 75
export var jump_impulse = 16
export var bounce_impulse = 16

var velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed('move_right'):
		direction.x += 1
	if Input.is_action_pressed('move_left'):
		direction.x -= 1
	if Input.is_action_pressed('move_back'):
		direction.z += 1
	if Input.is_action_pressed('move_forward'):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		
	var target_velocity = Vector3(direction.x * speed, velocity.y, direction.z * speed)
	
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
	else:
		target_velocity.y = 0
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	velocity = move_and_slide(target_velocity, Vector3.UP)
	
	# Iterate through all collisions that occurred this frame
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)

		if collision.collider and collision.collider.is_in_group("mob"):
			var mob = collision.collider
			# Check if the player is hitting the mob from above.
			if Vector3.UP.dot(collision.normal) > 0.1:
				# If so, squash the mob and bounce.
				if mob.has_method("squash"):
					mob.squash()
				velocity.y = bounce_impulse
				break
