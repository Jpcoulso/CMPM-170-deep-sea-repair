extends CharacterBody2D

@export var speed : float = 100.0
@export var detection_range : float = 150.0

var player : Node2D = null
var aggro : bool = false

func _ready():
	# Try to find the player automatically
	player = get_tree().get_first_node_in_group("player")
	$AnimatedSprite2D.play()

func _physics_process(_delta: float) -> void:
	if player == null:
		return

	var distance = position.distance_to(player.position)
	if distance < detection_range:
		aggro = true
	elif distance > detection_range * 1.2:
		aggro = false

	if aggro:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Optional: face player
	if velocity.length() > 5:
		rotation = velocity.angle()
