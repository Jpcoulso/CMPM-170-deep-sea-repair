extends Node2D

var exploded := false
var repaired := false
var player_in_repair_zone := false

signal repaired_signal

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var detonate_zone := $detonateZone               # Area2D
@onready var repair_area := $repaireArea                  # Area2D
@onready var repair_zone := $repaireArea/repairZone       # CollisionShape2D (no signals)

func _ready():
	sprite.modulate = Color(1, 1, 1)

	# Connect Area2D signals
	detonate_zone.connect("body_entered", Callable(self, "_on_detonate_zone_entered"))
	repair_area.connect("body_entered", Callable(self, "_on_repair_zone_entered"))
	repair_area.connect("body_exited", Callable(self, "_on_repair_zone_exited"))

func _on_detonate_zone_entered(body):
	if (body.is_in_group("player") or body.is_in_group("enemies")) and not exploded:
		exploded = true
		repaired = false
		anim.visible = true
		anim.play("explosion")
		anim.connect("animation_finished", Callable(self, "_on_explosion_finished"))

func _on_explosion_finished():
	sprite.modulate = Color(1.0, 0.3, 0.3)
	print("Beacon exploded! Now it can be repaired.")

func _on_repair_zone_entered(body):
	if body.is_in_group("player"):
		player_in_repair_zone = true

func _on_repair_zone_exited(body):
	if body.is_in_group("player"):
		player_in_repair_zone = false

func _process(_delta):
	if player_in_repair_zone and exploded and not repaired and Input.is_key_pressed(KEY_SPACE):
		repair()

func repair():
	repaired = true
	exploded = false
	sprite.modulate = Color(1, 1, 1)
	emit_signal("repaired_signal")
	print("Beacon repaired! It can now explode again.")
