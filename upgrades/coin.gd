class_name Coin
extends Node3D

var target: Player
var speed: float = 3
var gold: int = 0

func _process(delta: float) -> void:
	rotate(Vector3.UP, 0.3)
	if not target:
		target = get_tree().get_first_node_in_group("player")
		return
	global_position += global_position.direction_to(target.global_position) * speed * delta * Engine.physics_ticks_per_second

	if target.global_position.distance_to(global_position) < 1:
		Bank.gain_gold(gold)
		queue_free()
