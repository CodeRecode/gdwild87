extends Node3D

@export var speed = 8.0
@export var attack_damage = 4.0
@export var lifetime = 4.0

var direction

@onready var hitbox: Hitbox = $Hitbox

func _ready() -> void:
	hitbox.damage = attack_damage
	hitbox.area_entered.connect(_on_area_entered)

func set_direction(dir: Vector3) -> void:
	direction = dir

func _physics_process(delta: float) -> void:
	if direction:
		global_position += direction * delta * speed
	lifetime -= delta
	if lifetime < 0:
		expire()

func expire() -> void:
	queue_free()

func _on_area_entered(area: Node3D) -> void:
	if area is Hurtbox:
		call_deferred("queue_free")
