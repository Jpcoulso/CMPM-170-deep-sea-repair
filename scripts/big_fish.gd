extends CharacterBody2D

@export var speed: float = 100.0
@export var detection_range: float = 150.0

var player: Node2D = null
var aggro: bool = false
var is_dying: bool = false

func _ready():
	# Find player automatically (must be in "player" group)
	player = get_tree().get_first_node_in_group("player")
	
	# Play idle animation by default
	$AnimatedSprite2D.play("idle")
	
	# Connect collision detection
	$CollisionArea.body_entered.connect(_on_collision)
	
	# Delete fish after death animation finishes
	$AnimatedSprite2D.animation_finished.connect(_on_death_animation_finished)

func _physics_process(_delta: float) -> void:
	if is_dying:
		# Stop movement if dying
		velocity = Vector2.ZERO
		return
	
	if player == null:
		return

	# Aggro check
	var distance = position.distance_to(player.position)
	if distance < detection_range:
		aggro = true
	elif distance > detection_range * 1.2:
		aggro = false

	# Movement toward player
	if aggro:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Flip sprite depending on direction
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false

func _on_collision(body: CharacterBody2D) -> void:
	# Check for collision with beacon(s)
	if body.is_in_group("beacons"):
		print("should be dying")
		if not is_dying:
			is_dying = true
			$AnimatedSprite2D.play("death")
			

func _on_death_animation_finished():
	queue_free()
