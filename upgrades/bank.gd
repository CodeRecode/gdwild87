extends Node

signal gold_changed(amount: int)

var gold: int = 0

func gain_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold)

func spend_gold(amount: int) -> void:
	gold -= amount 

func calculate_cost(level: int) -> int:
	return level ** 2 + (1 * level)
	