extends Node3D

@onready var hitbox: Hitbox = $Hitbox
@onready var particles: PlayParticlesSystem = %Particles
@onready var damage_timer: Timer = %DamageTimer
@onready var queue_free_timer: Timer = %QueueFreeTimer

func _ready() -> void:
	particles.play_particles = true
	queue_free_timer.timeout.connect(queue_free)
	damage_timer.timeout.connect(func() -> void: hitbox.monitoring = true)
	
