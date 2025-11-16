extends Enemy

@export var Speed = 5.0
@export var Health = 10.0
@export var AttackDamage = 2.0

var target: Player
var can_attack: bool = false

func _ready() -> void:
	set_health(Health)

func _physics_process(delta: float) -> void:
	var delta_speed = Speed * delta * Engine.physics_ticks_per_second
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity.x = direction.x * delta_speed
		velocity.z = direction.z * delta_speed
	else:
		velocity.x = move_toward(velocity.x, 0, delta_speed)
		velocity.z = move_toward(velocity.z, 0, delta_speed)
	move_and_slide()
	
	_try_attack()
	
	
func _try_attack() -> void:
	if not can_attack:
		return
	target.apply_damage(AttackDamage)

func _on_vision_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body as Player

func _on_vision_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = null


func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_attack = true


func _on_attack_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_attack = false
