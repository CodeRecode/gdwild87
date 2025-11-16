extends CharacterBody3D
class_name Enemy

var health = 10.
var max_health = 10.

func set_health(new_health: float) -> void:
	max_health = new_health
	health = max_health

func apply_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		on_die()

func on_die() -> void:
	queue_free()
