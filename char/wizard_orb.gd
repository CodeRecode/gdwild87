extends Area3D

@export var Speed = 8.0
@export var AttackDamage = 4.0
@export var Lifetime = 4.0

var direction

func set_direction(dir: Vector3) -> void:
	direction = dir

func _physics_process(delta: float) -> void:
	if direction:
		global_position += direction * delta * Speed
	Lifetime -= delta
	if Lifetime < 0:
		expire()

func _on_body_entered(body: Node) -> void:
	if body is StaticBody3D:
		expire()		
	elif body.is_in_group("player"):
		print("hit")
		body.apply_damage(AttackDamage)
		expire()

func expire() -> void:
	queue_free()
