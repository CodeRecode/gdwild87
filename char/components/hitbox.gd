class_name Hitbox
extends Area3D

@export var continuous_hit := false
@export var damage: float

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _physics_process(_delta: float) -> void:
	if not continuous_hit:
		return
	for area in get_overlapping_areas():
		if area is Hurtbox:
			area.take_damage(damage)

func _on_area_entered(area: Area3D) -> void:
	if area is Hurtbox:
		area.take_damage(damage)
