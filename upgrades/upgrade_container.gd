class_name UpgradeContainer
extends PanelContainer

signal purchased(level: int)

var cost: int
var level: int

@onready var upgrade_level_label: Label = $Hbox/UpgradeLevel
@onready var buy_button: Button = $Hbox/Button

func _ready() -> void:
	buy_button.pressed.connect(_on_buy_button_pressed)

func setup(p_level: int) -> void:
	level = p_level
	cost = Bank.calculate_cost(level)
	upgrade_level_label.text = str(cost)
	buy_button.text = str(cost)
	if cost > Bank.gold:
		buy_button.disabled = true

func _on_buy_button_pressed() -> void:
	if cost > Bank.gold:
		return

	level += 1
	Bank.gold -= cost
	setup(level)
	purchased.emit(level)
	