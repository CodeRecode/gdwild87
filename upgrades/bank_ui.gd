class_name BankUI
extends Control

@onready var exit_button: Button = %ExitButton
@onready var attack_damage: UpgradeContainer = %AttackDamageContainer
@onready var attack_speed: UpgradeContainer = %AttackSpeedContainer
@onready var attack_range: UpgradeContainer = %AttackRangeContainer
@onready var movement: UpgradeContainer = %MovementSpeedContainer
@onready var max_health: UpgradeContainer = %MaxHealthContainer

func _ready() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	assert(player, "No player found!")

	exit_button.pressed.connect(_on_exit_button_pressed)

	attack_damage.purchased.connect(func(l: int) -> void: player.attack_damage_level = l) 
	attack_speed.purchased.connect(func(l: int) -> void: player.attack_speed_level = l) 
	attack_range.purchased.connect(func(l: int) -> void: player.attack_range_level = l) 
	movement.purchased.connect(func(l: int) -> void: player.speed_level = l) 
	max_health.purchased.connect(func(l: int) -> void: player.health_level = l) 

	attack_damage.setup(player.attack_damage_level)
	attack_speed.setup(player.attack_speed_level)
	attack_range.setup(player.attack_range_level)
	movement.setup(player.speed_level)
	max_health.setup(player.health_level)

func _on_exit_button_pressed() -> void:
	hide()
