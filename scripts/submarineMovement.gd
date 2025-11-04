extends CharacterBody2D

@export var speed : float = 200.0
@export var acceleration : float = 6.0
@export var water_drag : float = 3.0


func _physics_process(delta: float) -> void:
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Accelerate smoothly in input direction
	var target_velocity = input.normalized() * speed
	velocity = velocity.lerp(target_velocity, acceleration * delta)

	# Apply drag (slows down when not pressing)
	velocity *= (1.0 - water_drag * delta)

	move_and_slide()

	# Optional: rotate submarine toward movement direction
	if velocity.length() > 10:
		rotation = velocity.angle()
