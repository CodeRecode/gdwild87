class_name Hurtbox
extends Area3D

@export var health_component: HealthComponent
@export var invulnerability_time: float = 0.0
var invuln_time_left: float = 0.0

func _process(delta: float) -> void:
	invuln_time_left -= delta

func take_damage(dmg: float) -> void:
	if invuln_time_left < 0.0:
		health_component.take_damage(dmg)
		invuln_time_left = invulnerability_time
