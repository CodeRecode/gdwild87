class_name HealthComponent
extends Node

signal health_changed(prev: float, curr: float, max: float)
signal died

@export var max_health: float
var current_health: float

func _ready() -> void:
	current_health = max_health

func take_damage(dmg: float) -> void:
	var prev := current_health
	current_health -= clampf(dmg, 0, max_health)
	
	health_changed.emit(prev, current_health, max_health)
	if current_health <= 0:
		died.emit()

func take_healing(heal: float) -> void:
	var prev := current_health
	current_health = clampf(current_health + clampf(heal, 0, max_health), 0, max_health)

	health_changed.emit(prev, current_health, max_health)
