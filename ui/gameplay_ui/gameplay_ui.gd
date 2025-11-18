class_name GameplayUI
extends CanvasLayer

@export var healthbar_gradient: GradientTexture1D
var player: Player

@onready var coins_label: Label = %CoinsLabel
@onready var healthbar: ProgressBar = %Healthbar

func _ready() -> void:
	Bank.gold_changed.connect(_on_gold_changed)

func _process(_delta: float) -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return

	healthbar.max_value = player.InitMaxHealth
	healthbar.value = player.health
	var hp_percent := healthbar.max_value / healthbar.value
	healthbar.get("theme_override_styles/fill").bg_color = healthbar_gradient.gradient.sample(hp_percent)

func _on_gold_changed(gold: int) -> void:
	coins_label.text = str(gold)
