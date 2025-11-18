extends Node3D

var damage: float = 1.0
var damaged := false

@onready var area: Area3D = %Area3D
@onready var particles: PlayParticlesSystem = %Particles
@onready var damage_timer: Timer = %DamageTimer
@onready var queue_free_timer: Timer = %QueueFreeTimer

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	particles.play_particles = true
	queue_free_timer.timeout.connect(queue_free)
	damage_timer.timeout.connect(func() -> void: area.monitoring = true)
	
func _on_body_entered(body: Node3D) -> void:
	if damaged:
		return
	if body is Player:
		body.health -= damage
		damaged = true
