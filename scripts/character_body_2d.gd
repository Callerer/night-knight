extends CharacterBody2D

@onready var coyote_timer = $CoyoteTimer

const SPEED = 390.0
const JUMP_VELOCITY = -600.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() || !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
	elif velocity.y < 0.0:
		if Input.is_action_just_released("ui_accept"):
			velocity.y *= 0.4

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		# We use move_toward for basic acceleration/deceleration
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * 2.0 * delta) # Last value is acceleration
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 2.0 * delta) # Decelerate to a stop

	# checking before vs after mov n slide when jumoed to start coyote timer
	var was_on_floor = is_on_floor()

	move_and_slide()

	if was_on_floor && !is_on_floor():
		coyote_timer.start()
