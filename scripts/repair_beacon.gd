extends Area2D

var repaired = false
signal repaired_signal
var player_in_range = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		print("player in range")

func _on_body_exited(body):
	print("exited")
	if body.is_in_group("player"):
		player_in_range = false

func _process(_delta):
	if player_in_range and not repaired and Input.is_key_pressed(KEY_SPACE):
		repair()

func repair():
	repaired = true
	$Sprite2D.modulate = Color(1.0, 0.5, 0.5)
	emit_signal("repaired_signal")
	print("Beacon repaired!")
