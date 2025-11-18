extends CharacterBody3D
class_name Enemy

@export var gold_dropped: int = 1
var health = 10.
var max_health = 10.

@onready var coin_scene: PackedScene = preload("res://upgrades/coin.tscn")

func set_health(new_health: float) -> void:
	max_health = new_health
	health = max_health

func apply_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		on_die()

func on_die() -> void:
	_spawn_coins()
	queue_free()

func _spawn_coins() -> void:
	while gold_dropped > 0:
		var coin: Coin = coin_scene.instantiate()
		get_tree().root.add_child(coin)
		# Spawn them randomly within 1 unit of the enemy's body
		coin.global_position = global_position + (Vector3(randf(), 0, 0).rotated(Vector3.UP, randf() * 2 * PI))
		var gold := clampi(randi_range(1, 10), 1, gold_dropped)
		coin.gold = gold
		gold_dropped -= gold
